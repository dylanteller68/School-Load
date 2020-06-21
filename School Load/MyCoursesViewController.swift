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
		
	@IBOutlet weak var btn_SV: UIStackView!
	@IBOutlet weak var no_courses_lbl: UILabel!
	
	override func viewDidLoad() {
		
		self.progress_spinner.startAnimating()
		self.progress_spinner.isHidden = false
		
		if user.numCourses == 0 {
			no_courses_lbl.isHidden = false
		}
		
		user.courses = []
		
		// get courses
		db.collection("users").document(user.ID).collection("courses").order(by: "time")
			.addSnapshotListener { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				// error
				return
			}
			snapshot.documentChanges.forEach { diff in
				if (diff.type == .added) {
					let data = diff.document.data()
					
					let courseName = data["name"] as! String
					let courseColor = data["color"] as! Int
					let courseID = diff.document.documentID
					let numTodos = data["numTodos"] as! Int
					
					let course = Course(name: courseName, color: courseColor, ID: courseID, numTodos: numTodos)
					
					user.courses.append(course)
					user.numCourses = user.courses.count
					
					let title = NSMutableAttributedString()
					
					var cNameLen = 0

					let button = UIButton(type: .system)
					button.setAttributedTitle(title, for: .normal)
					button.titleLabel?.numberOfLines = 2
					button.titleLabel?.textAlignment = .center
					button.backgroundColor = .systemGray5
					button.translatesAutoresizingMaskIntoConstraints = false
					button.heightAnchor.constraint(equalToConstant: 90).isActive = true
					if numTodos == 1 {
						if courseName.count < 28 {
							cNameLen = courseName.count
							title.setAttributedString(NSMutableAttributedString(string: "\(courseName)\n\(numTodos) to-do", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin) ,NSAttributedString.Key.foregroundColor:user.colors[courseColor]]))
						} else {
							var tmpName = courseName
							tmpName.removeLast(courseName.count-28)
							tmpName.append("...")
							cNameLen = tmpName.count
							title.setAttributedString(NSMutableAttributedString(string: "\(tmpName)\n\(numTodos) to-do", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin) ,NSAttributedString.Key.foregroundColor:user.colors[courseColor]]))

						}
					} else {
						if courseName.count < 28 {
							cNameLen = courseName.count
							title.setAttributedString(NSMutableAttributedString(string: "\(courseName)\n\(numTodos) to-dos", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin) ,NSAttributedString.Key.foregroundColor:user.colors[courseColor]]))
						} else {
							var tmpName = courseName
							tmpName.removeLast(courseName.count-28)
							tmpName.append("...")
							cNameLen = tmpName.count
							title.setAttributedString(NSMutableAttributedString(string: "\(tmpName)\n\(numTodos) to-dos", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin) ,NSAttributedString.Key.foregroundColor:user.colors[courseColor]]))
						}
					}
					
					title.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .thin), range: NSRange(location: cNameLen, length: title.length-cNameLen))
					title.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: cNameLen, length: title.length-cNameLen))

					button.layer.cornerRadius = 25
					button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
					button.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
					button.tag = courseID.hashValue

					self.btn_SV.addArrangedSubview(button)
					
					self.no_courses_lbl.isHidden = true
					
				}
				if (diff.type == .modified) {
					let data = diff.document.data()
					
					let courseName = data["name"] as! String
					let courseColor = data["color"] as! Int
					let numTodos = data["numTodos"] as! Int

					for course in user.courses {
						if course.ID == diff.document.documentID {
							course.name = courseName
							course.color = courseColor
							course.numTodos = numTodos
						}
					}
					
					for t in user.todos {
						if t.course == diff.document.documentID {
							if t.color != courseColor {
								db.collection("users").document(user.ID).collection("to-dos").document(t.ID).updateData([
									"color" : courseColor
								])
								t.color = courseColor
							}
						}
					}
					
					user.numCourses = user.courses.count

					for var btn in self.btn_SV.arrangedSubviews {
						if btn.tag == diff.document.documentID.hashValue {
							let button = btn as! UIButton
							let title = NSMutableAttributedString()

							var cNameLen = 0

							if numTodos == 1 {
								if courseName.count < 28 {
									cNameLen = courseName.count
									title.setAttributedString(NSMutableAttributedString(string: "\(courseName)\n\(numTodos) to-do", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin) ,NSAttributedString.Key.foregroundColor:user.colors[courseColor]]))
								} else {
									var tmpName = courseName
									tmpName.removeLast(courseName.count-28)
									tmpName.append("...")
									cNameLen = tmpName.count
									title.setAttributedString(NSMutableAttributedString(string: "\(tmpName)\n\(numTodos) to-do", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin) ,NSAttributedString.Key.foregroundColor:user.colors[courseColor]]))

								}
							} else {
								if courseName.count < 28 {
									cNameLen = courseName.count
									title.setAttributedString(NSMutableAttributedString(string: "\(courseName)\n\(numTodos) to-dos", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin) ,NSAttributedString.Key.foregroundColor:user.colors[courseColor]]))
								} else {
									var tmpName = courseName
									tmpName.removeLast(courseName.count-28)
									tmpName.append("...")
									cNameLen = tmpName.count
									title.setAttributedString(NSMutableAttributedString(string: "\(tmpName)\n\(numTodos) to-dos", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin) ,NSAttributedString.Key.foregroundColor:user.colors[courseColor]]))
								}
							}

							title.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .thin), range: NSRange(location: cNameLen, length: title.length-cNameLen))
							title.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: cNameLen, length: title.length-cNameLen))

							button.setAttributedTitle(title, for: .normal)
							
							btn = button
						}
					}
					
				}
				if (diff.type == .removed) {
					
					for btn in self.btn_SV.arrangedSubviews {
						if btn.tag == diff.document.documentID.hashValue {
							self.btn_SV.removeArrangedSubview(btn)
							btn.removeFromSuperview()
						}
					}

					user.courses.removeAll(where: {$0.ID == diff.document.documentID})
					user.numCourses = user.courses.count
					
					db.collection("users").document(user.ID).updateData([
						"numCourses" : user.numCourses
					])
				}
			}
			if user.courses.count == 0 {
				self.no_courses_lbl.isHidden = false
			}
			self.progress_spinner.stopAnimating()
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

}
