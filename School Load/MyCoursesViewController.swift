//
//  SecondViewController.swift
//  School Load
//
//  Created by Dylan Teller on 3/29/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyCoursesViewController: UIViewController {
	
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var btn_SV: UIStackView!
	@IBOutlet weak var no_courses_lbl: UILabel!
	
	override func viewDidLoad() {
		
		self.progress_spinner.startAnimating()
		self.progress_spinner.isHidden = false
		
		if user.courses.count == 0 {
			no_courses_lbl.isHidden = false
			progress_spinner.stopAnimating()
		}
		
		user.courses = []
		
		// get courses
		db.collection("users").document(user.ID).collection("courses").order(by: "time", descending: false)
			.addSnapshotListener { (snapshot, error) in
			if error == nil {
				snapshot!.documentChanges.forEach { diff in
					if (diff.type == .added) {
						let data = diff.document.data()
						
						let courseName = data["name"] as! String
						let courseColor = data["color"] as! Int
						let courseID = diff.document.documentID
						let time = data["time"] as! Timestamp
						
						let course = Course(name: courseName, color: courseColor, ID: courseID, numTodos: 0, time: time.dateValue())

						if user.courses.count != 0 {
							if user.courses[user.courses.count-1].ID != course.ID {
								user.courses.append(course)
							}
						} else {
							user.courses.append(course)
						}
						
						
						self.redraw_screen()
					}
					if (diff.type == .modified) {
						let data = diff.document.data()
						
						let courseName = data["name"] as! String
						let courseColor = data["color"] as! Int

						for course in user.courses {
							if course.ID == diff.document.documentID {
								course.name = courseName
								course.color = courseColor
								course.numTodos = 0
							}
						}
						
						for t in user.todos {
							if t.course == diff.document.documentID {
								db.collection("users").document(user.ID).collection("to-dos").document(t.ID).updateData([
									"color" : courseColor,
									"courseID" : diff.document.documentID,
									"dateModified" : Timestamp(date: Date())
								])
								t.color = courseColor
								t.course = diff.document.documentID
							}
						}
						
						for t in user.completed {
							if t.course == diff.document.documentID {
								db.collection("users").document(user.ID).collection("completed").document(t.ID).updateData([
									"color" : courseColor,
									"courseID" : diff.document.documentID,
									"dateModified" : Timestamp(date: Date())
								])
								t.color = courseColor
								t.course = diff.document.documentID
							}
						}
						
						self.redraw_screen()
						
					}
					if (diff.type == .removed) {
						user.courses.removeAll(where: {$0.ID == diff.document.documentID})
						self.redraw_screen()
					}
					if user.courses.count != 0 {
						self.no_courses_lbl.isHidden = true
					} else {
						self.no_courses_lbl.isHidden = false
					}
				}
			}
			if user.courses.count == 0 {
				self.no_courses_lbl.isHidden = false
			}
			self.progress_spinner.stopAnimating()
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if user.coursesShouldUpdate {
			redraw_screen()
			user.coursesShouldUpdate = false
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is CourseTodosViewController {
			let v = segue.destination as! CourseTodosViewController
			let tid = sender as? UIButton
			v.sent_tID = tid!.tag
		}
	}
	
	@objc func btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
		performSegue(withIdentifier: "course_todos_segue", sender: sender)
	}

	func redraw_screen() {
		for v in self.btn_SV.arrangedSubviews {
			self.btn_SV.removeArrangedSubview(v)
			v.removeFromSuperview()
		}
		
		user.sortCourses()
		
		for c in user.courses {
			c.numTodos = 0
			for t in user.todos {
				if t.course == c.ID {
					c.numTodos += 1
				}
			}
			
			var btnColor: UIColor
			if self.traitCollection.userInterfaceStyle == .dark {
				btnColor = .white
			} else {
				btnColor = .black
			}
			
			if UIDevice().model != "iPad" {
				let btn1 = UIButton(type: .system)
				btn1.setAttributedTitle(NSAttributedString(string: "\(c.name)", attributes: [NSAttributedString.Key.foregroundColor: user.colors[c.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin)]), for: .normal)
				btn1.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
				btn1.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
				btn1.tag = c.ID.hashValue
				btn1.titleLabel?.lineBreakMode = .byTruncatingTail
				
				let btn2 = UIButton(type: .system)
				if c.numTodos != 1 {
				btn2.setAttributedTitle(NSAttributedString(string: "\(c.numTodos) To-dos", attributes: [NSAttributedString.Key.foregroundColor: btnColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)]), for: .normal)
				} else {
					btn2.setAttributedTitle(NSAttributedString(string: "\(c.numTodos) To-do", attributes: [NSAttributedString.Key.foregroundColor: btnColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)]), for: .normal)
				}
				btn2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
				btn2.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
				btn2.tag = c.ID.hashValue
				btn2.titleLabel?.lineBreakMode = .byTruncatingTail

				let course_btn_SV = UIStackView(arrangedSubviews: [btn1, btn2])
				course_btn_SV.axis = .vertical
				course_btn_SV.alignment = .center
				course_btn_SV.distribution = .fillEqually
				course_btn_SV.spacing = 0
				course_btn_SV.addBackground(color: .systemGray5, tag: c.ID.hashValue)
				course_btn_SV.heightAnchor.constraint(equalToConstant: 90).isActive = true
				let subv = course_btn_SV.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
				
				self.btn_SV.addArrangedSubview(course_btn_SV)
			} else {
				let btn1 = UIButton(type: .system)
				if c.numTodos != 1 {
				btn1.setAttributedTitle(NSAttributedString(string: "\(c.name) • \(c.numTodos) To-dos", attributes: [NSAttributedString.Key.foregroundColor: user.colors[c.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .thin)]), for: .normal)
				} else {
					btn1.setAttributedTitle(NSAttributedString(string: "\(c.name) • \(c.numTodos) To-do", attributes: [NSAttributedString.Key.foregroundColor: user.colors[c.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .thin)]), for: .normal)
				}
				btn1.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
				btn1.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
				btn1.tag = c.ID.hashValue
				btn1.titleLabel?.lineBreakMode = .byTruncatingTail
				
				let course_btn_SV = UIStackView(arrangedSubviews: [btn1])

				user.sortTodos()
				var i = 0
				for t in user.todos {
					if t.course == c.ID {
						if i < 5 {
							let btn2 = UIButton(type: .system)
							let formatter2 = DateFormatter()
							formatter2.dateStyle = .full
							var tdDate = formatter2.string(from: t.date)
							tdDate.removeLast(6)
							let formatter1 = DateFormatter()
							formatter1.timeStyle = .short
							let tDate = formatter1.string(from: t.date)
							btn2.setAttributedTitle(NSAttributedString(string: "\(t.name) • \(tdDate), \(tDate)", attributes: [NSAttributedString.Key.foregroundColor: btnColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)]), for: .normal)
							btn2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
							btn2.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
							btn2.tag = c.ID.hashValue
							btn2.titleLabel?.lineBreakMode = .byTruncatingMiddle
							course_btn_SV.addArrangedSubview(btn2)
						} else {
							let btn2 = UIButton(type: .system)
							btn2.setAttributedTitle(NSAttributedString(string: "...", attributes: [NSAttributedString.Key.foregroundColor: btnColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)]), for: .normal)
							btn2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
							btn2.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
							btn2.tag = c.ID.hashValue
							btn2.titleLabel?.lineBreakMode = .byTruncatingMiddle
							course_btn_SV.addArrangedSubview(btn2)
							break
						}
						i += 1
					}
				}

				course_btn_SV.axis = .vertical
				course_btn_SV.alignment = .center
				course_btn_SV.spacing = 0
				course_btn_SV.addBackground(color: .systemGray5, tag: c.ID.hashValue)
				if c.numTodos > 0 {
					course_btn_SV.heightAnchor.constraint(equalToConstant: 250).isActive = true
					course_btn_SV.setCustomSpacing(10, after: btn1)
					course_btn_SV.distribution = .fillProportionally
				} else {
					course_btn_SV.heightAnchor.constraint(equalToConstant: 130).isActive = true
					course_btn_SV.distribution = .equalSpacing
				}
				let subv = course_btn_SV.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
				
				self.btn_SV.addArrangedSubview(course_btn_SV)
			}
		}
	}
}

extension UIStackView {
	func addBackground(color: UIColor, tag: Int) {
        let subview = UIButton(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		subview.layer.cornerRadius = 25
		subview.tag = tag
        insertSubview(subview, at: 0)
    }
}
