//
//  FirstViewController.swift
//  School Load
//
//  Created by Dylan Teller on 3/29/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications

class MyTodosViewController: UIViewController {
	
	@IBOutlet weak var no_todos_lbl: UILabel!
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var btn_SV: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		user.completed = []
		user.todos = []
		user.courses = []

		progress_spinner.startAnimating()
		progress_spinner.isHidden = false
		
		if Auth.auth().currentUser != nil {
			// logged in
			// set up user
			let currentUser = Auth.auth().currentUser
			user.ID = currentUser!.uid
			
			db.collection("users").document(user.ID).getDocument { (DocumentSnapshot, error) in
				if error == nil {
					let data = DocumentSnapshot?.data()
					
					let userFName = data!["first name"] as! String
					let userLName = data!["last name"] as? String ?? ""
					let userEmail = currentUser?.email
					let notificationHour = data!["notificationHour"] as! Int
					let notificationMinute = data!["notificationMinute"] as! Int
					
					// populate user object
					user.fname = userFName
					user.lname = userLName
					user.email = userEmail!
					user.notificationHour = notificationHour
					user.notificationMinute = notificationMinute
				} else {
					// error
				}
			}

			db.collection("users").document(user.ID).collection("courses").order(by: "time").getDocuments { (querySnapshot, error) in
				if error == nil {
					for document in querySnapshot!.documents {
						let data = document.data()
						
						let cName = data["name"] as! String
						let cColor = data["color"] as! Int
						let cID = document.documentID
						let time = data["time"] as! Timestamp
						
						let course = Course(name: cName, color: cColor, ID: cID, numTodos: 0, time: time.dateValue())
						
						user.courses.append(course)
						
					}
					
					// get to-dos
					db.collection("users").document(user.ID).collection("to-dos").order(by: "date")
					.addSnapshotListener { querySnapshot, error in
						guard let snapshot = querySnapshot else {
							// error
							return
						}
						snapshot.documentChanges.forEach { diff in
							if (diff.type == .added) {
								
								// ADDED**********************************************************************
								
								self.no_todos_lbl.isHidden = true

								let data = diff.document.data()
								
								let todoName = data["name"] as! String
								let todoCourseID = data["courseID"] as! String
								let todoDate = data["date"] as! Timestamp
								let todoAdded = data["dateAdded"] as! Timestamp
								let todoColorIndex = data["color"] as! Int
								let todoNote = data["note"] as? String ?? "Add note..."

								let todo = Todo(name: todoName, course: todoCourseID, date: todoDate.dateValue(), dateAdded: todoAdded.dateValue(), color: todoColorIndex, ID: diff.document.documentID, note: todoNote)
								
								if user.todos.count != 0 {
									if !user.todos.contains(where: {$0.ID == todo.ID}) {
										user.todos.append(todo)
										for c in user.courses {
											if c.ID == todoCourseID {
												c.numTodos += 1
											}
										}
									}
								} else {
									user.todos.append(todo)
									for c in user.courses {
										if c.ID == todoCourseID {
											c.numTodos += 1
										}
									}
								}
								
							}
							if (diff.type == .modified) {
								
								// MODIFIED*******************************************************************
								
								let data = diff.document.data()
								
								let todoName = data["name"] as! String
								let todoCourseID = data["courseID"] as! String
								let todoDate = data["date"] as! Timestamp
								let todoAdded = data["dateAdded"] as! Timestamp
								let formatter1 = DateFormatter()
								formatter1.timeStyle = .short
								let todoColorIndex = data["color"] as! Int
								let todoNote = data["note"] as? String ?? "Add note..."
								
								for todo in user.todos {
									if todo.ID == diff.document.documentID {
										todo.name = todoName
										todo.course = todoCourseID
										todo.date = todoDate.dateValue()
										todo.dateAdded = todoAdded.dateValue()
										todo.color = todoColorIndex
										todo.note = todoNote
									}
								}
														
								for c in user.courses {
									c.numTodos = 0
								}
								
								for c in user.courses {
									for t in user.todos {
										if c.ID == t.course {
											c.numTodos += 1
										}
									}
								}

							}
							if (diff.type == .removed) {
								
								// REMOVED*********************************************************************
														
								user.todos.removeAll(where: {$0.ID == diff.document.documentID})
								
								for c in user.courses {
									c.numTodos = 0
								}
								
								for c in user.courses {
									for t in user.todos {
										if c.ID == t.course {
											c.numTodos += 1
										}
									}
								}
														
							}
						}
						
						for c in user.courses {
							c.numTodos = 0
							for t in user.todos {
								if c.ID == t.course {
									c.numTodos += 1
								}
							}
						}
												
						if user.todos.count == 0 {
							self.no_todos_lbl.isHidden = false
						}
						self.progress_spinner.stopAnimating()
						self.redraw_screen()
					}
				}
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if Auth.auth().currentUser == nil {
			performSegue(withIdentifier: "not_logged_in", sender: self)
		} else if user.needsToGoToCourses {
			tabBarController?.selectedIndex = 1
			user.needsToGoToCourses = false
		} else if user.needsToGoToMe {
			tabBarController?.selectedIndex = 2
			user.needsToGoToMe = false
		} else {
			
			let df1 = DateFormatter()
			df1.dateStyle = .full
			let openDateFormatted = df1.string(from: OPEN_DATE)
			
			let df2 = DateFormatter()
			df2.dateStyle = .full
			let thisDateFormatted = df2.string(from: Date())
			
			if openDateFormatted != thisDateFormatted {
				redraw_screen()
			}
			
		}
		no_todos_lbl.text = "No to-dos yet"
	}
	
	@objc func done_btn_tapped(sender: UIButton) {
		
		let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
		notificationFeedbackGenerator.prepare()
		notificationFeedbackGenerator.notificationOccurred(.success)

		sender.isEnabled = false
		
		for t in user.todos {
			if t.ID.hashValue == sender.tag {
				let todo = Todo(name: t.name, course: t.course, date: t.date, dateCompleted: Date(), dateAdded: t.dateAdded, color: t.color, ID: t.ID, note: t.note)
				db.collection("users").document(user.ID).collection("completed").document(t.ID).setData([
					"name" : t.name,
					"courseID" : t.course,
					"color" : t.color,
					"date" : Timestamp(date: t.date),
					"date completed" : Timestamp(date: todo.dateCompleted),
					"dateAdded" : t.dateAdded,
					"note" : t.note
				])
				break
			}
		}
		
		for v in self.btn_SV.arrangedSubviews {
			if v.tag == sender.tag {
				let sv = v as? UIStackView
				let v1 = sv?.arrangedSubviews[1] as? UIStackView
				let v2 = sv?.arrangedSubviews[2] as? UIButton
				let ats = NSAttributedString(string: "Done!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .thin)])
				let ats2 = NSAttributedString(string: "Nice job, \(user.fname)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .thin)])
				let subv1 = v1?.arrangedSubviews[0] as? UIButton
				let subv2 = v1?.arrangedSubviews[1] as? UIButton
				subv1?.setAttributedTitle(ats, for: .normal)
				subv2?.setAttributedTitle(ats2, for: .normal)
				subv2?.titleLabel?.lineBreakMode = .byTruncatingTail
				v2?.tintColor = .systemGreen
				break
			}
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			UIView.animate(withDuration: 0.5) {
				for v in self.btn_SV.arrangedSubviews {
					if v.tag == sender.tag {
						self.btn_SV.removeArrangedSubview(v)
						v.removeFromSuperview()
						self.view.layoutIfNeeded()
					}
				}
			}
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			for t in user.todos {
				if t.ID.hashValue == sender.tag {
					db.collection("users").document(user.ID).collection("to-dos").document(t.ID).delete()
				}
			}
		}
	}
	
	@objc func btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
		performSegue(withIdentifier: "todo_info_segue", sender: sender)
	}
	
	@IBAction func new_todo_btn(_ sender: Any) {
		if user.courses.count == 0 {
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			no_todos_lbl.text = "Add a course first"
			no_todos_lbl.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.no_todos_lbl.textColor = .label
			}
		} else {
			performSegue(withIdentifier: "new_todo_segue", sender: self)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is TodoInfoViewController {
			let v = segue.destination as! TodoInfoViewController
			let tid = sender as? UIButton
			v.sent_tid = tid!.tag
		}
	}
	
	func redraw_screen() {
		
		user.sortTodos()
				
		for v in self.btn_SV.arrangedSubviews {
			self.btn_SV.removeArrangedSubview(v)
			v.removeFromSuperview()
		}
		
		user.numTodosToday = 0
		
		for t in user.todos {
			let formatter1 = DateFormatter()
			formatter1.timeStyle = .short
			let tDate = formatter1.string(from: t.date)
			var tCourseName = ""
			for c in user.courses {
				if c.ID == t.course {
					tCourseName = c.name
				}
			}
			
			let df = DateFormatter()
			df.dateStyle = .full
			var todoDateFormatted = df.string(from: t.date)
			todoDateFormatted.removeLast(6)
			
			let df2 = DateFormatter()
			df2.dateStyle = .full
			var todaysDateFormatted = df2.string(from: Date())
			todaysDateFormatted.removeLast(6)
			
			if todoDateFormatted == todaysDateFormatted {
				user.numTodosToday += 1
			}
			
			let bullet_btn = UIButton(type: .system)
			bullet_btn.setTitle("", for: .normal)
			bullet_btn.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
			bullet_btn.widthAnchor.constraint(equalToConstant: 5).isActive = true
			bullet_btn.tintColor = user.colors[t.color]
			bullet_btn.tag = t.ID.hashValue
			bullet_btn.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
			
			let done_btn = UIButton(type: .system)
			done_btn.setTitle("", for: .normal)
			done_btn.setBackgroundImage(UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
			done_btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
			done_btn.tintColor = .label
			done_btn.tag = t.ID.hashValue
			done_btn.addTarget(self, action: #selector(self.done_btn_tapped), for: .touchUpInside)
			
			let btn1 = UIButton(type: .system)
			let title = NSMutableAttributedString(string: "\(t.name)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
			btn1.setAttributedTitle(title, for: .normal)
			btn1.contentHorizontalAlignment = .leading
			btn1.titleLabel?.lineBreakMode = .byTruncatingTail
			btn1.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
			btn1.tag = t.ID.hashValue
			
			let btn2 = UIButton(type: .system)
			let title2 = NSMutableAttributedString(string: "\(tDate) • \(tCourseName)", attributes: [
				NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .thin), NSAttributedString.Key.foregroundColor: UIColor.label])
			title2.addAttribute(NSAttributedString.Key.foregroundColor, value: user.colors[t.color], range: NSRange(location: tDate.count+2, length: tCourseName.count+1))
			btn2.setAttributedTitle(title2, for: .normal)
			btn2.contentHorizontalAlignment = .leading
			btn2.titleLabel?.lineBreakMode = .byTruncatingTail
			btn2.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
			btn2.tag = t.ID.hashValue
			
			let btn = UIStackView(arrangedSubviews: [btn1, btn2])
			btn.axis = .vertical
			btn.distribution = .fillEqually
			btn.spacing = 10

			// individual todo SV
			let todo_SV = UIStackView(arrangedSubviews: [bullet_btn, btn, done_btn])
			todo_SV.axis = .horizontal
			todo_SV.spacing = 15
			todo_SV.tag = btn1.tag
			todo_SV.heightAnchor.constraint(equalToConstant: 40).isActive = true

			let formatter2 = DateFormatter()
			formatter2.dateStyle = .full
			var tdDate = formatter2.string(from: t.date)
			tdDate.removeLast(6)
			let date_lbl = UILabel()
			let todaysDate = Date()
			let formatter3 = DateFormatter()
			formatter3.dateStyle = .full
			var todayDate = formatter3.string(from: todaysDate)
			todayDate.removeLast(6)
			let tomorrowsDate = Date().addingTimeInterval(86400)
			var tomorrowDate = formatter3.string(from: tomorrowsDate)
			tomorrowDate.removeLast(6)
			date_lbl.font = .systemFont(ofSize: 20)
			if todayDate == tdDate {
				tdDate.append(" (Today)")
				let attrstr = NSMutableAttributedString(string: tdDate)
				attrstr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .thin), range: NSRange(location: tdDate.count-7, length: 7))
				date_lbl.attributedText = attrstr
			} else if tomorrowDate == tdDate {
				tdDate.append(" (Tomorrow)")
				let attrstr = NSMutableAttributedString(string: tdDate)
				attrstr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .thin), range: NSRange(location: tdDate.count-10, length: 10))
				date_lbl.attributedText = attrstr
			} else if t.date < Date() {
				tdDate.append(" (Past Due)")
				let attrstr = NSMutableAttributedString(string: tdDate)
				attrstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemRed, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)], range: NSRange(location: tdDate.count-10, length: 10))
				date_lbl.attributedText = attrstr
			} else {
				date_lbl.text = tdDate
			}
			
			let numTodosPerDate_lbl = UILabel()
			var numTodosPerDate = 0
			for td in user.todos {
				let dform = DateFormatter()
				dform.dateStyle = .full
				var compdate = dform.string(from: td.date)
				compdate.removeLast(6)
				if todayDate == compdate {
					compdate.append(" (Today)")
				} else if tomorrowDate == compdate {
					compdate.append(" (Tomorrow)")
				} else if t.date < Date() {
					compdate.append(" (Past Due)")
				}
				if compdate == date_lbl.text {
					numTodosPerDate += 1
				}
			}
			numTodosPerDate_lbl.textColor = .systemGray2
			numTodosPerDate_lbl.text = "\(numTodosPerDate)"
			
			let date_SV = UIStackView(arrangedSubviews: [date_lbl, numTodosPerDate_lbl])
			if UIDevice().model != "iPad" {
				date_SV.distribution = .fillProportionally
			}
			let view = UIView()
			view.heightAnchor.constraint(equalToConstant: 1).isActive = true
			view.backgroundColor = .systemGray4
			
			var mustAddDate = true
			for v in self.btn_SV.arrangedSubviews {
				let sv = v as? UIStackView
				let dlbl = sv?.arrangedSubviews[0] as? UILabel
				if dlbl?.text == tdDate {
					mustAddDate = false
					break
				}
			}
			
			if mustAddDate {
				self.btn_SV.addArrangedSubview(date_SV)
				self.btn_SV.setCustomSpacing(5, after: date_SV)
				self.btn_SV.addArrangedSubview(view)
			}
			
			self.btn_SV.addArrangedSubview(todo_SV)

		}
	}
}
