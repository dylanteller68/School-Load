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
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var btn_SV: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

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
					let userLName = data!["last name"] as! String
					let userEmail = currentUser?.email
					let numCourses = data!["numCourses"] as! Int
					
					// populate user object
					user.fname = userFName
					user.lname = userLName
					user.email = userEmail!
					user.numCourses = numCourses
					
				} else {
					// error
				}
			}
			
			user.completed = []
			user.todos = []
			user.courses = []

			db.collection("users").document(user.ID).collection("courses").order(by: "time").getDocuments(source: .cache) { (querySnapshot, error) in
				if error == nil {
					for document in querySnapshot!.documents {
						let data = document.data()
						
						let cName = data["name"] as! String
						let cColor = data["color"] as! Int
						let cID = document.documentID
						let numTodos = 0
						
						let course = Course(name: cName, color: cColor, ID: cID, numTodos: numTodos)
						
						user.courses.append(course)
						
					}
				} else {
					// error probably first time launching from device
					db.collection("users").document(user.ID).collection("courses").order(by: "time").getDocuments { (querySnapshot, error) in
						if error == nil {
							for document in querySnapshot!.documents {
								let data = document.data()
								
								let cName = data["name"] as! String
								let cColor = data["color"] as! Int
								let cID = document.documentID
								let numTodos = 0
								
								let course = Course(name: cName, color: cColor, ID: cID, numTodos: numTodos)
								
								user.courses.append(course)
								
							}
						} else {
							// error
						}
					}
					
				}
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
						let todoColorIndex = data["color"] as! Int

						let todo = Todo(name: todoName, course: todoCourseID, date: todoDate.dateValue(), color: todoColorIndex, ID: diff.document.documentID)
						
						user.todos.append(todo)
											
						for c in user.courses {
							if c.ID == todoCourseID {
								c.numTodos += 1
								db.collection("users").document(user.ID).collection("courses").document(c.ID).updateData([
									"numTodos" : c.numTodos
								])
							}
						}
						
					}
					if (diff.type == .modified) {
						
						// MODIFIED*******************************************************************
						
						let data = diff.document.data()
						
						let todoName = data["name"] as! String
						let todoCourseID = data["courseID"] as! String
						let todoDate = data["date"] as! Timestamp
						let formatter1 = DateFormatter()
						formatter1.timeStyle = .short
						let todoColorIndex = data["color"] as! Int
						
						for todo in user.todos {
							if todo.ID == diff.document.documentID {
								todo.name = todoName
								todo.course = todoCourseID
								todo.date = todoDate.dateValue()
								todo.color = todoColorIndex
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
						
						for c in user.courses {
							db.collection("users").document(user.ID).collection("courses").document(c.ID).updateData([
								"numTodos" : c.numTodos
							])
						}

					}
					if (diff.type == .removed) {
						
						// REMOVED*********************************************************************
						
						let data = diff.document.data()
						
						user.todos.removeAll(where: {$0.ID == diff.document.documentID})
						
						for c in user.courses {
							if c.ID == data["courseID"] as! String {
								c.numTodos -= 1
								db.collection("users").document(user.ID).collection("courses").document(data["courseID"] as! String).updateData([
									"numTodos" : c.numTodos
								])
							}
						}
												
					}
					
					let center = UNUserNotificationCenter.current()
					center.removeAllPendingNotificationRequests()
					center.requestAuthorization(options: [.sound, .alert]) { (granted, error) in
					}

					let content = UNMutableNotificationContent()
					if user.numTodosToday == 1 {
						content.body = "You have \(user.numTodosToday) to-do today"
					} else {
						content.body = "You have \(user.numTodosToday) to-dos today"
					}

			//		let date = Date().addingTimeInterval(10)
			//
			//		let dc = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

					var dc = DateComponents()
					dc.calendar = Calendar.current
					dc.hour = 8

					let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)

					let uuidString = UUID().uuidString

					let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

					center.add(request) { (error) in
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
				
	}
	
	@objc func done_btn_tapped(sender: UIButton) {

		sender.isEnabled = false
		
		for t in user.todos {
			if t.ID.hashValue == sender.tag {
				let todo = Todo(name: t.name, course: t.course, date: t.date, dateCompleted: Date(), color: t.color, ID: t.ID)
				db.collection("users").document(user.ID).collection("completed").document(t.ID).setData([
					"name" : t.name,
					"courseID" : t.course,
					"color" : t.color,
					"date" : Timestamp(date: t.date),
					"date completed" : Timestamp(date: todo.dateCompleted)
				])
				break
			}
		}
		
		for v in self.btn_SV.arrangedSubviews {
			if v.tag == sender.tag {
				let sv = v as? UIStackView
				let v1 = sv?.arrangedSubviews[1] as? UIButton
				let v2 = sv?.arrangedSubviews[2] as? UIButton
				let ats = NSAttributedString(string: "Done!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
				v1?.setAttributedTitle(ats, for: .normal)
				v2?.tintColor = .systemGreen
				v1?.isEnabled = false
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
		
		performSegue(withIdentifier: "edit_todo_segue", sender: sender)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditTodoViewController {
			let v = segue.destination as! EditTodoViewController
			let tid = sender as? UIButton
			v.sent_tID = tid!.tag
		}
	}
	
	@IBAction func new_todo_btn(_ sender: Any) {
		if user.courses.count == 0 {
			tabBarController?.selectedIndex = 1
		} else {
			performSegue(withIdentifier: "new_todo_segue", sender: self)
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
			let tNameLen = t.name.count
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
			
			if tCourseName.count > 25 {
				tCourseName.removeLast(tCourseName.count-25)
				tCourseName.append("...")
			}
			
			let bullet_btn = UIButton(type: .system)
			bullet_btn.setTitle("", for: .normal)
			bullet_btn.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
			bullet_btn.widthAnchor.constraint(equalToConstant: 5).isActive = true
			bullet_btn.tintColor = user.colors[t.color]
			bullet_btn.tag = t.ID.hashValue
			
			let done_btn = UIButton(type: .system)
			done_btn.setTitle("", for: .normal)
			done_btn.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
			done_btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
			done_btn.tintColor = .label
			done_btn.tag = t.ID.hashValue
			done_btn.addTarget(self, action: #selector(self.done_btn_tapped), for: .touchUpInside)
			
			let btn = UIButton(type: .system)
			
			if tNameLen < 28 {
				let title = NSMutableAttributedString(string: "\(t.name)\n\(tDate) • \(tCourseName)", attributes: [NSAttributedString.Key.foregroundColor: user.colors[t.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
				title.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: tNameLen+tDate.count+3))
				title.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .thin), range: NSRange(location: tNameLen, length: title.length-tNameLen))
				btn.setAttributedTitle(title, for: .normal)
			} else {
				var tmpName = t.name
				tmpName.removeLast(tNameLen-27)
				tmpName.append("...")
				let title = NSMutableAttributedString(string: "\(tmpName)\n\(tDate) • \(tCourseName)", attributes: [NSAttributedString.Key.foregroundColor: user.colors[t.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
				title.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: tmpName.count+tDate.count+3))
				title.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .thin), range: NSRange(location: tmpName.count, length: title.length-tmpName.count))
				btn.setAttributedTitle(title, for: .normal)
			}

			btn.titleLabel?.numberOfLines = 2
			btn.contentHorizontalAlignment = .leading
			btn.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
			btn.tag = t.ID.hashValue

			// individual todo SV
			let todo_SV = UIStackView(arrangedSubviews: [bullet_btn, btn, done_btn])
			todo_SV.axis = .horizontal
			todo_SV.spacing = 15
			todo_SV.tag = btn.tag
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
			if todayDate == tdDate {
				tdDate.append(" (Today)")
			}
			date_lbl.text = tdDate
			date_lbl.font = .systemFont(ofSize: 20)
			
			let numTodosPerDate_lbl = UILabel()
			var numTodosPerDate = 0
			for td in user.todos {
				let dform = DateFormatter()
				dform.dateStyle = .full
				var compdate = dform.string(from: td.date)
				compdate.removeLast(6)
				if todayDate == compdate {
					compdate.append(" (Today)")
				}
				if compdate == date_lbl.text {
					numTodosPerDate += 1
				}
			}
			numTodosPerDate_lbl.textColor = .systemGray2
			numTodosPerDate_lbl.text = "\(numTodosPerDate)"
			
			let date_SV = UIStackView(arrangedSubviews: [date_lbl, numTodosPerDate_lbl])
			
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