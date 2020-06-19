//
//  NewCourseViewController.swift
//  School Load
//
//  Created by Dylan Teller on 4/7/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NewCourseViewController: UIViewController {
	
	@IBOutlet weak var course_name_txtbx: UITextField!
	@IBOutlet weak var course_color_btn: UIButton!
	@IBOutlet weak var add_course_btn: UIButton!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		course_color_btn.layer.cornerRadius = 10
		add_course_btn.layer.cornerRadius = 25
		course_name_txtbx.layer.cornerRadius = 25
    }
	
	var i = 0
	var color_has_been_tapped = false

	@IBAction func add_course_tapped(_ sender: Any) {
		
		course_name_txtbx.resignFirstResponder()
		
		let numColor = i
		let cName = course_name_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
				
		if cName != "" {
			
			add_course_btn.isEnabled = false
			
			add_course_btn.setTitle("", for: .normal)
			progress_spinner.startAnimating()
			progress_spinner.isHidden = false
						
			db.collection("users").document(user.ID).collection("courses").document().setData([
				"name" : cName,
				"color" : numColor,
				"numTodos": 0,
				"time" : Timestamp()
			]) { (error) in
				if error != nil {
					self.progress_spinner.stopAnimating()
					self.add_course_btn.setTitle("Oops, try again", for: .normal)
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.add_course_btn.setTitle("Add Course", for: .normal)
					}
					
					self.add_course_btn.isEnabled = true
				} else {
					self.progress_spinner.stopAnimating()
					self.add_course_btn.setTitle("Course Added", for: .normal)
					
					db.collection("users").document(user.ID).updateData([
						"numCourses" : user.numCourses
					])
					
					self.add_course_btn.isEnabled = false
					
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

	@IBAction func color_tapped(_ sender: Any) {
		
		color_has_been_tapped = true
		
		i += 1

		if i == user.colors.count {
			i = 0
		}
		
		course_color_btn.backgroundColor = user.colors[i]
		
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func course_name_txtbx_done(_ sender: Any) {
		course_name_txtbx.resignFirstResponder()
	}
	
}