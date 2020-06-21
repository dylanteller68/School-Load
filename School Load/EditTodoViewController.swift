//
//  EditTodoViewController.swift
//  School Load
//
//  Created by Dylan Teller on 4/27/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EditTodoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	@IBOutlet weak var new_todo_lbl: UIStackView!
	@IBOutlet weak var choose_course_btn: UIButton!
	@IBOutlet weak var course_picker: UIPickerView!
	@IBOutlet weak var todo_txtbx: UITextField!
	@IBOutlet weak var add_todo_btn: UIButton!
	@IBOutlet weak var date_picker: UIDatePicker!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var delete_btn: UIButton!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	
	var course_picker_is_showing = false
	
	var sent_tID = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()

		choose_course_btn.layer.cornerRadius = 10
		
        course_picker.delegate = self
        course_picker.dataSource = self
		
		add_todo_btn.layer.cornerRadius = 25
		
		for t in user.todos {
			if t.ID.hashValue == sent_tID {
				todo_txtbx.text = t.name
				todo_txtbx.textColor = user.colors[t.color]
				var a = 0
				for i in 0..<user.courses.count {
					if t.course == user.courses[i].ID {
						a = i
						break
					}
				}
				course_picker.selectRow(a, inComponent: 0, animated: true)
				date_picker.setDate(t.date, animated: true)
				break
			}
		}
		
		if UIDevice().model == "iPad" {
			btn_width_constraint.constant += 225
			SV_width_constraint.constant += 225
		}
    }
    
	@IBAction func edit_todo_tapped(_ sender: Any) {
		
		todo_txtbx.resignFirstResponder()
		
		progress_spinner.startAnimating()
		progress_spinner.isHidden = false
		
		var todo_to_edit: Todo? = nil

		for t in user.todos {
			if t.ID.hashValue == sent_tID {
				todo_to_edit = t
				break
			}
		}
		
		let editedTodoName: String = todo_txtbx.text ?? ""
		let selectedRow = course_picker.selectedRow(inComponent: 0)
		let editedTodoColor = user.courses[selectedRow].color
		let editedTodoCourse = user.courses[selectedRow].ID
		let editedTodoDate = date_picker.date
		
		if editedTodoName != "" {
			add_todo_btn.isEnabled = false
			delete_btn.isEnabled = false

			db.collection("users").document(user.ID).collection("to-dos").document(todo_to_edit!.ID).updateData([
				"name" : editedTodoName,
				"color" : editedTodoColor,
				"courseID" : editedTodoCourse,
				"date" : Timestamp(date: editedTodoDate)
			])
			
			progress_spinner.stopAnimating()
						
			add_todo_btn.setTitle("To-do Edited", for: .normal)
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.dismiss(animated: true, completion: nil)
			}
		} else {
			progress_spinner.stopAnimating()
			todo_txtbx.text = "To-do Name"
			todo_txtbx.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.todo_txtbx.text = ""
				self.todo_txtbx.textColor = user.colors[ user.courses[self.course_picker.selectedRow(inComponent: 0)].color]
			}
		}
					
	}
	
	@IBAction func choose_course_tapped(_ sender: Any) {
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
		todo_txtbx.resignFirstResponder()
	}
	
	@IBAction func txtbx_done(_ sender: Any) {
		todo_txtbx.resignFirstResponder()
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
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
	
	@IBAction func delete_todo_tapped(_ sender: Any) {
		
		delete_btn.isEnabled = false
		add_todo_btn.isEnabled = false
		
		var id = ""
		
		for t in user.todos {
			if t.ID.hashValue == sent_tID {
				id = t.ID
			}
		}
		
		db.collection("users").document(user.ID).collection("to-dos").document(id).delete()
		
		delete_btn.setTitle("To-do Deleted", for: .normal)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.dismiss(animated: true, completion: nil)
		}
	}
	
}
