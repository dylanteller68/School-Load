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
	@IBOutlet weak var scrollview: UIScrollView!
	@IBOutlet weak var numTodosLbl: UILabel!
	
	var sent_tID = 0
	var numTs = 0

    override func viewDidLoad() {
        super.viewDidLoad()
		progress_spinner.startAnimating()
		progress_spinner.isHidden = false
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if user.needsToGoToCourses {
			self.dismiss(animated: true, completion: nil)
			user.needsToGoToCourses = false
		}
		
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
				if numTs == 1 {
					numTodosLbl.text = "\(numTs) To-do"
				} else {
					numTodosLbl.text = "\(numTs) To-dos"
				}
				cName_lbl.textColor = user.colors[c.color]
				break
			}
		}
		
		user.sortTodos()

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
					btn1.addTarget(self, action: #selector(self.btn_tapped), for: .touchUpInside)
					btn1.tag = t.ID.hashValue
					
					let btn2 = UIButton(type: .system)
					let title2 = NSMutableAttributedString(string: "\(tDate)", attributes: [
						NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .thin), NSAttributedString.Key.foregroundColor: UIColor.label])
					btn2.setAttributedTitle(title2, for: .normal)
					btn2.contentHorizontalAlignment = .leading
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
						if td.course.hashValue == sent_tID {
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
		if segue.destination is EditCourseViewController {
			let v = segue.destination as! EditCourseViewController
			let cid = sender as? UIButton
			v.sent_cID = cid!.tag
		}
	}
	
	@objc func btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
			//performSegue(withIdentifier: "todo_info_segue", sender: sender)
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
				let ats2 = NSAttributedString(string: "Nice Job", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .thin)])
				let subv1 = v1?.arrangedSubviews[0] as? UIButton
				let subv2 = v1?.arrangedSubviews[1] as? UIButton
				subv1?.setAttributedTitle(ats, for: .normal)
				subv2?.setAttributedTitle(ats2, for: .normal)
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
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.viewDidAppear(true)
		}
	}
	
	@IBAction func more_btn_tapped(_ sender: UIButton) {
		performSegue(withIdentifier: "edit_course_segue", sender: sender)
	}
	
}
