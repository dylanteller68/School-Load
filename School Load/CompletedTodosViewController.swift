//
//  CompletedTodosViewController.swift
//  School Load
//
//  Created by Dylan Teller on 4/28/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase

class CompletedTodosViewController: UIViewController {

	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var btn_SV: UIStackView!
	@IBOutlet weak var no_completed_lbl: UILabel!
	@IBOutlet weak var clear_btn: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		progress_spinner.startAnimating()
		progress_spinner.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {

		
		user.completed = []
		
		db.collection("users").document(user.ID).collection("completed").getDocuments { (querySnapshot, error) in
			if error == nil {
				for document in querySnapshot!.documents {
					let data = document.data()
					
					let tName = data["name"] as! String
					let tColor = data["color"] as! Int
					let cID = data["courseID"] as! String
					let tDate = data["date"] as! Timestamp
					let dComp = data["date completed"] as! Timestamp
					let tNote = data["note"] as? String ?? "Add note..."

					let todo = Todo(name: tName, course: cID, date: tDate.dateValue(), dateCompleted: dComp.dateValue(), color: tColor, ID: document.documentID, note: tNote)
					
					user.completed.append(todo)
					
				}
				
				for v in self.btn_SV.arrangedSubviews {
					self.btn_SV.removeArrangedSubview(v)
					v.removeFromSuperview()
				}
				
				if user.completed.count > 0 {
					self.no_completed_lbl.isHidden = true
					self.clear_btn.isHidden = false
				} else {
					self.no_completed_lbl.isHidden = false
				}
				self.progress_spinner.stopAnimating()

				
				user.sortCompleted()
				
				for t in user.completed {
					let tNameLen = t.name.count
					var tCourseName = ""
					for c in user.courses {
						if c.ID == t.course {
							tCourseName = c.name
						}
					}
					if tCourseName.count > 33 {
						tCourseName.removeLast(tCourseName.count-33)
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
					done_btn.setBackgroundImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
					done_btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
					done_btn.tintColor = .label
					done_btn.tag = t.ID.hashValue
					done_btn.addTarget(self, action: #selector(self.add_btn_tapped), for: .touchUpInside)
					
					let btn = UIButton(type: .system)
					
					if tNameLen < 28 {
						let title = NSMutableAttributedString(string: "\(t.name)\n\(tCourseName)", attributes: [NSAttributedString.Key.foregroundColor: user.colors[t.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
						title.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: tNameLen))
						title.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .thin), range: NSRange(location: tNameLen, length: title.length-tNameLen))
						btn.setAttributedTitle(title, for: .normal)
					} else {
						var tmpName = t.name
						tmpName.removeLast(tNameLen-28)
						tmpName.append("...")
						let title = NSMutableAttributedString(string: "\(tmpName)\n\(tCourseName)", attributes: [NSAttributedString.Key.foregroundColor: user.colors[t.color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
						title.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: tmpName.count))
						title.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .thin), range: NSRange(location: tmpName.count, length: title.length-tmpName.count))
						btn.setAttributedTitle(title, for: .normal)
					}

					btn.titleLabel?.numberOfLines = 2
					btn.contentHorizontalAlignment = .leading
					btn.tag = t.ID.hashValue

					// individual todo SV
					let todo_SV = UIStackView(arrangedSubviews: [bullet_btn, btn, done_btn])
					todo_SV.axis = .horizontal
					todo_SV.spacing = 15
					todo_SV.tag = btn.tag
					todo_SV.heightAnchor.constraint(equalToConstant: 40).isActive = true
								
					self.btn_SV.addArrangedSubview(todo_SV)

				}
				
			} else {
				// error
			}
		}
	}

	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func clear_tapped(_ sender: Any) {
		
		clear_btn.setTitle("Clearing...", for: .normal)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			for v in self.btn_SV.arrangedSubviews {
				
				let t = v as? UIStackView
				
				for comp in user.completed {
					if comp.ID.hashValue == t?.tag {
						db.collection("users").document(user.ID).collection("completed").document(comp.ID).delete()
					}
				}
				
				self.btn_SV.removeArrangedSubview(v)
				v.removeFromSuperview()
			}
			
			user.completed.removeAll()
			
			self.no_completed_lbl.isHidden = false
			self.clear_btn.isHidden = true
		}
	}
	
	@objc func add_btn_tapped(sender: UIButton) {
		
		sender.tintColor = .systemTeal
		
		sender.isEnabled = false
		
		for v in self.btn_SV.arrangedSubviews {
			if v.tag == sender.tag {
				let sv = v as? UIStackView
				let v1 = sv?.arrangedSubviews[1] as? UIButton
				let v2 = sv?.arrangedSubviews[2] as? UIButton
				
				let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
				notificationFeedbackGenerator.prepare()
				notificationFeedbackGenerator.notificationOccurred(.success)
				
				let ats = NSAttributedString(string: "Added!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .thin)])
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
		
		for t in user.completed {
			if t.ID.hashValue == sender.tag {
				db.collection("users").document(user.ID).collection("to-dos").document(t.ID).setData([
					"name" : t.name,
					"date" : Timestamp(date: t.date),
					"courseID" : t.course,
					"color" : t.color
				])
				
				db.collection("users").document(user.ID).collection("completed").document(t.ID).delete()
				user.completed.removeAll(where: {$0.ID == t.ID})
				if user.completed.count == 0 {
					self.no_completed_lbl.isHidden = false
					self.clear_btn.isHidden = true
				}
				break
			}
		}
		
	}
	
}
