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
		
	}
    
	@IBAction func edit_course_tapped(_ sender: Any) {
		
		course_name_txtbx.resignFirstResponder()
		
		let numColor = i
		let cName = course_name_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

		if cName != "" {
			edit_course_btn.isEnabled = false
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
					self.edit_course_btn.setTitle("Oops, try again", for: .normal)
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.edit_course_btn.setTitle("Edit Course", for: .normal)
					}
					
					self.edit_course_btn.isEnabled = true
					self.delete_btn.isEnabled = true
					
				} else {
					self.progress_spinner.stopAnimating()
					self.edit_course_btn.setTitle("Course Edited", for: .normal)
					
					db.collection("users").document(user.ID).updateData([
						"numCourses" : user.numCourses
					])
										
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.dismiss(animated: true, completion: nil)
					}
				}
			}
		} else {
			progress_spinner.stopAnimating()
			course_name_txtbx.text = "Course Name"
			course_name_txtbx.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.course_name_txtbx.text = ""
				self.course_name_txtbx.textColor = .white
			}
		}
		
	}
	
	@IBAction func delete_course_tapped(_ sender: Any) {
		
		if confirm_delete_lbl.isHidden {
			confirm_delete_lbl.isHidden = false
		} else {
			
			confirm_delete_lbl.isHidden = true
			
			delete_btn.isEnabled = false
			edit_course_btn.isEnabled = false
			
			var id = ""

			for c in user.courses {
				if c.ID.hashValue == sent_cID {
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
					self.delete_btn.setTitle("Course Deleted", for: .normal)

					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						user.needsToGoToCourses = true
						self.performSegue(withIdentifier: "deleted_course_segue", sender: self)
					}
				}
			}
			
		}
		
	}
	
	@IBAction func txtbx_done(_ sender: Any) {
		course_name_txtbx.resignFirstResponder()
	}
	
	@IBAction func color_btn_tapped(_ sender: Any) {
		
		i += 1

		if i == user.colors.count {
			i = 0
		}
		
		color_btn.backgroundColor = user.colors[i]
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
}