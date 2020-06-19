//
//  CourseTodosViewController.swift
//  School Load
//
//  Created by Dylan Teller on 4/29/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase

class CourseTodosViewController: UIViewController {
	
	@IBOutlet weak var btn_SV: UIStackView!
	@IBOutlet weak var no_todos_lbl: UILabel!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var cName_lbl: UILabel!
	@IBOutlet weak var more_btn: UIButton!
	
	var sent_tID = 0
	var numTs = 0

    override func viewDidLoad() {
        super.viewDidLoad()
		progress_spinner.startAnimating()
		progress_spinner.isHidden = false
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		for c in user.courses {
			if c.ID.hashValue == sent_tID {
				more_btn.tag = sent_tID
				numTs = c.numTodos
				if c.name.count < 25 {
					cName_lbl.text = c.name
				} else {
					var tmpName = c.name
					tmpName.removeLast(c.name.count-25)
					tmpName.append("...")
					cName_lbl.text = tmpName
				}
				cName_lbl.textColor = user.colors[c.color]
				break
			}
		}
		
		for v in self.btn_SV.arrangedSubviews {
			self.btn_SV.removeArrangedSubview(v)
			v.removeFromSuperview()
		}
		
		if numTs == 0 {
			no_todos_lbl.isHidden = false
		} else {
			no_todos_lbl.isHidden = true
			for t in user.todos {
				if t.course.hashValue == sent_tID {
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
					if tCourseName.count > 23 {
						tCourseName.removeLast(tCourseName.count-23)
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
					done_btn.tintColor = .white
					done_btn.tag = t.ID.hashValue
					done_btn.addTarget(self, action: #selector(self.done_btn_tapped), for: .touchUpInside)
					
					let btn = UIButton(type: .system)
					
					if tNameLen < 28 {
						let title = NSMutableAttributedString(string: "\(t.name)\n\(tDate)", attributes: [NSAttributedString.Key.foregroundColor: user.colors[t.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
						title.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: tNameLen+tDate.count+1))
						title.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .thin), range: NSRange(location: tNameLen, length: title.length-tNameLen))
						btn.setAttributedTitle(title, for: .normal)
					} else {
						var tmpName = t.name
						tmpName.removeLast(tNameLen-28)
						tmpName.append("...")
						let title = NSMutableAttributedString(string: "\(tmpName)\n\(tDate)", attributes: [NSAttributedString.Key.foregroundColor: user.colors[t.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
						title.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: tmpName.count+tDate.count+1))
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
							if td.course.hashValue == sent_tID {
								numTodosPerDate += 1
							}
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
		progress_spinner.stopAnimating()
	}

	@IBAction func close_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditTodoViewController {
			let v = segue.destination as! EditTodoViewController
			let tid = sender as? UIButton
			v.sent_tID = tid!.tag
		}
		
		if segue.destination is EditCourseViewController {
			let v = segue.destination as! EditCourseViewController
			let cid = sender as? UIButton
			v.sent_cID = cid!.tag
		}
	}
	
	@objc func btn_tapped(sender: UIButton) {
		
		performSegue(withIdentifier: "edit_course_todo_segue", sender: sender)
		
	}
	
	@objc func done_btn_tapped(sender: UIButton) {
		
		sender.isEnabled = false

		for t in user.todos {
			if t.ID.hashValue == sender.tag {
				let todo = Todo(name: t.name, course: t.course, date: t.date, dateCompleted: Date(), color: t.color, ID: t.ID)
				user.completed.append(todo)
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
		
		for t in user.todos {
			if t.ID.hashValue == sender.tag {
				db.collection("users").document(user.ID).collection("to-dos").document(t.ID).delete()
			}
		}
				
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
			self.viewDidAppear(true)
		}
	}
	
	@IBAction func more_btn_tapped(_ sender: UIButton) {
		performSegue(withIdentifier: "edit_course_segue", sender: sender)
	}
	
}