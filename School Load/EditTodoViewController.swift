//
//  EditTodoViewController.swift
//  School Load
//
//  Created by Dylan Teller on 8/11/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import Firebase

class EditTodoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	@IBOutlet weak var course_btn: UIButton!
	@IBOutlet weak var todo_name_txtbx: UITextField!
	@IBOutlet weak var addTodo_btn: UIButton!
	@IBOutlet weak var course_picker: UIPickerView!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var editTodo_lbl: UIStackView!
	@IBOutlet weak var delete_btn: UIButton!
	@IBOutlet weak var delete_progress_spinner: UIActivityIndicatorView!
	
	var sent_tID = 0
	var tID = ""
	var course_picker_is_showing = false
	
	override func viewDidLoad() {
        super.viewDidLoad()

		course_btn.layer.cornerRadius = 10
		
        self.course_picker.delegate = self
        self.course_picker.dataSource = self
		
		addTodo_btn.layer.cornerRadius = 25
		
		for t in user.todos {
			if t.ID.hashValue == sent_tID {
				tID = t.ID
				todo_name_txtbx.textColor = user.colors[t.color]
				todo_name_txtbx.text = t.name
				datePicker.date = t.date
				for i in 0..<user.courses.count {
					if user.courses[i].ID == t.course {
						course_picker.selectRow(i, inComponent: 0, animated: true)
						break
					}
				}
				break
			}
		}
    }

	@IBAction func add_todo_tapped(_ sender: Any) {
		addTodo_btn.isEnabled = false
		
		todo_name_txtbx.resignFirstResponder()
		
		let todoName = todo_name_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		
		if todoName != "" {
			progress_spinner.startAnimating()
			progress_spinner.isHidden = false
			addTodo_btn.setTitle("", for: .normal)
			
			let cIndex = course_picker.selectedRow(inComponent: 0)
			
			let todoColor = user.courses[cIndex].color
			let todoCourse = user.courses[cIndex].ID
			let todoDate = datePicker.date
			
			db.collection("users").document(user.ID).collection("to-dos").document(tID).updateData([
				"name" : todoName,
				"courseID" : todoCourse,
				"date" : Timestamp(date: todoDate),
				"dateModified" : Timestamp(date: Date()),
				"color" : todoColor
			])
			
			progress_spinner.stopAnimating()
			
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.success)
			addTodo_btn.setTitle("To-do Edited", for: .normal)
						
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.dismiss(animated: true, completion: nil)
			}
			
		} else {
			progress_spinner.stopAnimating()
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			todo_name_txtbx.text = "To-do Name"
			todo_name_txtbx.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.todo_name_txtbx.text = ""
				self.todo_name_txtbx.textColor = user.colors[ user.courses[self.course_picker.selectedRow(inComponent: 0)].color]
				self.addTodo_btn.isEnabled = true
			}
		}
	}
	
	@IBAction func choose_course_tapped(_ sender: Any) {
		if course_picker_is_showing {
			// accept tapped
			let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
			selectionFeedbackGenerator.selectionChanged()
			
			course_picker.isHidden = true
			editTodo_lbl.isHidden = false
			course_btn.setBackgroundImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
			course_btn.tintColor = .systemTeal
			course_picker_is_showing = false
			let cIndex = course_picker.selectedRow(inComponent: 0)
			let color = user.colors[user.courses[cIndex].color]
			todo_name_txtbx.textColor = color
			datePicker.isHidden = false
			addTodo_btn.isHidden = false
		} else {
			// pick course tapped
			course_picker.isHidden = false
			editTodo_lbl.isHidden = true
			course_btn.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
			course_btn.tintColor = .systemGreen
			course_picker_is_showing = true
		}
		
		todo_name_txtbx.resignFirstResponder()
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
	
	@IBAction func txtbx_done(_ sender: Any) {
		todo_name_txtbx.resignFirstResponder()
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func delete_tapped(_ sender: Any) {
		alert_delete()
	}
	
	func alert_delete() {
		delete_btn.isHidden = true
		delete_progress_spinner.startAnimating()
		delete_progress_spinner.isHidden = false
		let alert = UIAlertController(title: "Delete To-do", message: "This cannot be undone.", preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			self.delete_btn.isHidden = false
			self.delete_progress_spinner.stopAnimating()
		}))
		alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
			self.addTodo_btn.setTitle("", for: .normal)
			self.progress_spinner.startAnimating()
			self.progress_spinner.isHidden = false
			
			self.delete_btn.isEnabled = false
			self.addTodo_btn.isEnabled = false

			for t in user.todos {
				if t.ID == self.tID {
					db.collection("users").document(user.ID).collection("to-dos").document(t.ID).delete { (error) in
						if error == nil {
							let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
							notificationFeedbackGenerator.prepare()
							notificationFeedbackGenerator.notificationOccurred(.success)

							DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
								user.needsToGoToTodos = true
								self.dismiss(animated: true, completion: nil)
							}
						}
					}
					break
				}
			}
			
			self.progress_spinner.stopAnimating()
			self.addTodo_btn.setTitle("To-do Deleted", for: .normal)
			self.delete_btn.isHidden = false
			self.delete_progress_spinner.stopAnimating()
		}))
		alert.popoverPresentationController?.sourceView = delete_btn
		present(alert, animated: true)
	}
}
