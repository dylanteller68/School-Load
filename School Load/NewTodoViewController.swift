//
//  NewTodoViewController.swift
//  School Load
//
//  Created by Dylan Teller on 4/11/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NewTodoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	@IBOutlet weak var new_todo_lbl: UIStackView!
	@IBOutlet weak var choose_course_btn: UIButton!
	@IBOutlet weak var course_picker: UIPickerView!
	@IBOutlet weak var todo_txtbx: UITextField!
	@IBOutlet weak var add_todo_btn: UIButton!
	@IBOutlet weak var date_picker: UIDatePicker!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var txtbx_constraint: NSLayoutConstraint!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	
	var course_picker_is_showing = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

		choose_course_btn.layer.cornerRadius = 10
		
        self.course_picker.delegate = self
        self.course_picker.dataSource = self
		
		add_todo_btn.layer.cornerRadius = 25
		
		if UIDevice().model == "iPad" {
			self.txtbx_constraint.constant -= 80
			self.view.layoutIfNeeded()
			date_picker.isHidden = false
			add_todo_btn.isHidden = false
			btn_width_constraint.constant += 225
			SV_width_constraint.constant += 225
		}
    }
	
	@IBAction func add_todo_tapped(_ sender: Any) {
		
		todo_txtbx.resignFirstResponder()
		
		let todoName = todo_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		
		if todoName != "" {
			add_todo_btn.isEnabled = false
			
			progress_spinner.startAnimating()
			progress_spinner.isHidden = false
			add_todo_btn.setTitle("", for: .normal)
			
			let cIndex = course_picker.selectedRow(inComponent: 0)
			
			let todoColor = user.courses[cIndex].color
			let todoCourse = user.courses[cIndex].ID
			let todoDate = date_picker.date
			
			db.collection("users").document(user.ID).collection("to-dos").addDocument(data: [
				"name" : todoName,
				"courseID" : todoCourse,
				"date" : Timestamp(date: todoDate),
				"color" : todoColor,
				"note" : "Add note..."
			])
			
			progress_spinner.stopAnimating()
			
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.success)
			add_todo_btn.setTitle("To-do Added", for: .normal)
						
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.dismiss(animated: true, completion: nil)
			}
			
		} else {
			progress_spinner.stopAnimating()
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			todo_txtbx.text = "To-do Name"
			todo_txtbx.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.todo_txtbx.text = ""
				self.todo_txtbx.textColor = user.colors[ user.courses[self.course_picker.selectedRow(inComponent: 0)].color]
			}
		}
	}
	
	@IBAction func choose_course_tapped(_ sender: Any) {
		switch UIDevice().model {
		case "iPad":
			if course_picker_is_showing {
				// accept tapped
				course_picker.isHidden = true
				new_todo_lbl.isHidden = false
				choose_course_btn.setBackgroundImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
				choose_course_btn.tintColor = .systemTeal
				course_picker_is_showing = false
				let cIndex = course_picker.selectedRow(inComponent: 0)
				let color = user.colors[user.courses[cIndex].color]
				todo_txtbx.textColor = color
			} else {
				// pick course tapped
				course_picker.isHidden = false
				new_todo_lbl.isHidden = true
				choose_course_btn.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
				choose_course_btn.tintColor = .systemGreen
				course_picker_is_showing = true
			}
			break
		default:
			if course_picker_is_showing {
				// accept tapped
				let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
				selectionFeedbackGenerator.selectionChanged()
				
				course_picker.isHidden = true
				new_todo_lbl.isHidden = false
				choose_course_btn.setBackgroundImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
				choose_course_btn.tintColor = .systemTeal
				course_picker_is_showing = false
				let cIndex = course_picker.selectedRow(inComponent: 0)
				let color = user.colors[user.courses[cIndex].color]
				todo_txtbx.textColor = color
				if date_picker.isHidden && add_todo_btn.isHidden {
					UIView.animate(withDuration: 0.5) {
						self.txtbx_constraint.constant -= 80
						self.view.layoutIfNeeded()
					}
				}
				date_picker.isHidden = false
				add_todo_btn.isHidden = false
			} else {
				// pick course tapped
				course_picker.isHidden = false
				new_todo_lbl.isHidden = true
				choose_course_btn.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
				choose_course_btn.tintColor = .systemGreen
				course_picker_is_showing = true
			}
			break
		}

		todo_txtbx.resignFirstResponder()
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return user.courses.count
	}
	
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		let title = NSMutableAttributedString(string: "\(user.courses[row].name)", attributes: [NSAttributedString.Key.foregroundColor: user.colors[user.courses[row].color], NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)])
		return title
	}

	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func todo_txtbx_done(_ sender: Any) {
		todo_txtbx.resignFirstResponder()
	}
}
