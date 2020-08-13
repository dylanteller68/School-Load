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
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var txtbx_constraint: NSLayoutConstraint!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	
	var didTapTxtbx = false
	
	override func viewDidLoad() {
        super.viewDidLoad()

		course_color_btn.layer.cornerRadius = 10
		add_course_btn.layer.cornerRadius = 25
		course_name_txtbx.layer.cornerRadius = 25
		
		if UIDevice().model == "iPad" {
			SV_width_constraint.constant += 100
			btn_width_constraint.constant += 100
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		course_name_txtbx.becomeFirstResponder()
	}
	
	var i = 0
	var color_has_been_tapped = false

	@IBAction func add_course_tapped(_ sender: Any) {
		
		add_course_btn.isEnabled = false
		
		course_name_txtbx.resignFirstResponder()
		
		let numColor = i
		let cName = course_name_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
				
		if cName != "" {
			add_course_btn.setTitle("", for: .normal)
			progress_spinner.startAnimating()
			progress_spinner.isHidden = false
			
			db.collection("users").document(user.ID).collection("courses").addDocument(data: [
				"name" : cName,
				"color" : numColor,
				"time" : Timestamp(date: Date()),
				"numTodos" : 0
			]) { (error) in
				if error == nil {
					self.progress_spinner.stopAnimating()
					
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.success)
					
					self.add_course_btn.setTitle("Course Added", for: .normal)
					
					self.add_course_btn.isEnabled = false
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.dismiss(animated: true, completion: nil)
					}
				} else {
					self.progress_spinner.stopAnimating()
					
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.error)
					
					self.add_course_btn.setTitle("Oops, try again", for: .normal)
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.add_course_btn.setTitle("Add Course", for: .normal)
					}
					
					self.add_course_btn.isEnabled = true
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
				self.add_course_btn.isEnabled = true
			}
		}
	}

	@IBAction func color_tapped(_ sender: Any) {
		
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
		color_has_been_tapped = true
		
		i += 1
		if i == user.colors.count {
			i = 0
		}
		
		course_color_btn.backgroundColor = user.colors[i]
		
		if UIDevice().model == "iPad" {
			txtbx_constraint.constant += 80
		}
		didTapTxtbx = false
		course_name_txtbx.resignFirstResponder()

	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func txtbx_tapped(_ sender: Any) {
		if !didTapTxtbx {
			if UIDevice().model == "iPad" {
				txtbx_constraint.constant -= 80
			}
			didTapTxtbx = true
		}
	}
	
	@IBAction func course_name_txtbx_done(_ sender: Any) {
		if UIDevice().model == "iPad" {
			txtbx_constraint.constant += 80
		}
		didTapTxtbx = false
		course_name_txtbx.resignFirstResponder()
	}
	
}
