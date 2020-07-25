//
//  EditCourseViewController.swift
//  School Load
//
//  Created by Dylan Teller on 5/15/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase

class EditCourseViewController: UIViewController {
	
	@IBOutlet weak var color_btn: UIButton!
	@IBOutlet weak var edit_course_btn: UIButton!
	@IBOutlet weak var course_name_txtbx: UITextField!
	@IBOutlet weak var delete_btn: UIButton!
	@IBOutlet weak var confirm_delete_lbl: UILabel!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	
	var sent_cID = 0
	var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()

		color_btn.layer.cornerRadius = 10
		edit_course_btn.layer.cornerRadius = 25
		
		for c in user.courses {
			if c.ID.hashValue == sent_cID {
				course_name_txtbx.text = c.name
				color_btn.backgroundColor = user.colors[c.color]
				i = c.color
			}
		}
		
		if UIDevice().model == "iPad" {
			btn_width_constraint.constant += 225
			SV_width_constraint.constant += 225
		}
	}
    
	@IBAction func edit_course_tapped(_ sender: Any) {
		
		edit_course_btn.isEnabled = false

		course_name_txtbx.resignFirstResponder()
		
		let numColor = i
		let cName = course_name_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

		if cName != "" {
			delete_btn.isEnabled = false
			
			edit_course_btn.setTitle("", for: .normal)
			progress_spinner.startAnimating()
			progress_spinner.isHidden = false
			
			var numTodos = 0
			var id = ""
			
			for c in user.courses {
				if c.ID.hashValue == sent_cID {
					numTodos = c.numTodos
					id = c.ID
				}
			}
						
			db.collection("users").document(user.ID).collection("courses").document(id).updateData([
				"name" : cName,
				"color" : numColor,
				"numTodos": numTodos,
				"time" : Timestamp()
			]) { (error) in
				if error != nil {
					self.progress_spinner.stopAnimating()
					
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.error)
					
					self.edit_course_btn.setTitle("Oops, try again", for: .normal)
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.edit_course_btn.setTitle("Edit Course", for: .normal)
					}
					
					self.edit_course_btn.isEnabled = true
					self.delete_btn.isEnabled = true
					
				} else {
					self.progress_spinner.stopAnimating()
					
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.success)
					
					self.edit_course_btn.setTitle("Course Edited", for: .normal)
										
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.dismiss(animated: true, completion: nil)
					}
				}
			}
		} else {
			progress_spinner.stopAnimating()
			
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			
			course_name_txtbx.text = "Course Name"
			course_name_txtbx.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.course_name_txtbx.text = ""
				self.course_name_txtbx.textColor = .white
				self.edit_course_btn.isEnabled = true
			}
		}
		
	}
	
	@IBAction func delete_course_tapped(_ sender: Any) {
		alert_delete()
	}
	
	@IBAction func txtbx_done(_ sender: Any) {
		course_name_txtbx.resignFirstResponder()
	}
	
	@IBAction func color_btn_tapped(_ sender: Any) {
		
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
		i += 1
		if i == user.colors.count {
			i = 0
		}
		
		color_btn.backgroundColor = user.colors[i]
		
		course_name_txtbx.resignFirstResponder()
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func alert_delete() {
		let alert = UIAlertController(title: "Delete Course", message: "All to-dos associated with this course will also be deleted. This cannot be undone.", preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in	}))
		alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
			
			self.edit_course_btn.setTitle("", for: .normal)
			self.progress_spinner.startAnimating()
			self.progress_spinner.isHidden = false
			
			self.delete_btn.isEnabled = false
			self.edit_course_btn.isEnabled = false

			var id = ""

			for c in user.courses {
				if c.ID.hashValue == self.sent_cID {
					id = c.ID
					for t in user.todos {
						if t.course == c.ID {
							db.collection("users").document(user.ID).collection("to-dos").document(t.ID).delete()
						}
					}
					break
				}
			}

			db.collection("users").document(user.ID).collection("courses").document(id).delete { (error) in
				if error == nil {
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.success)

					self.confirm_delete_lbl.textColor = .systemRed
					self.confirm_delete_lbl.text = "Course Deleted"

					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						user.needsToGoToCourses = true
						self.dismiss(animated: true, completion: nil)
					}
				}
			}
			
			self.progress_spinner.stopAnimating()
			self.edit_course_btn.setTitle("Course Deleted", for: .normal)
		}))
		
		present(alert, animated: true)
	}
	
}
