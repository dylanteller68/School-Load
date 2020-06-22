//
//  TodoInfoViewController.swift
//  School Load
//
//  Created by Dylan Teller on 6/21/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class TodoInfoViewController: UIViewController, UITextViewDelegate {

	@IBOutlet weak var todo_name_lbl: UILabel!
	@IBOutlet weak var todo_date_lbl: UILabel!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var more_btn: UIButton!
	@IBOutlet weak var note_txtview: UITextView!
	
	var sent_tID = 0
	var tID = ""

	override func viewDidLoad() {
        super.viewDidLoad()
		
		progress_spinner.startAnimating()
		progress_spinner.isHidden = false
		
		note_txtview.layer.cornerRadius = 10

		for t in user.todos {
			if t.ID.hashValue == sent_tID {
				let formatter1 = DateFormatter()
				formatter1.timeStyle = .short
				let tDate = formatter1.string(from: t.date)
				
				let df = DateFormatter()
				df.dateStyle = .full
				var todoDateFormatted = df.string(from: t.date)
				todoDateFormatted.removeLast(6)
				
				todo_name_lbl.text = t.name
				todo_name_lbl.textColor = user.colors[t.color]
				todo_date_lbl.text = "\(todoDateFormatted) • \(tDate)"
				note_txtview.text = t.note
				progress_spinner.stopAnimating()
				more_btn.tag = t.ID.hashValue
				tID = t.ID
				break
			}
		}
		
		note_txtview.delegate = self
    }
	
	override func viewDidAppear(_ animated: Bool) {
		for t in user.todos {
			if t.ID.hashValue == sent_tID {
				let formatter1 = DateFormatter()
				formatter1.timeStyle = .short
				let tDate = formatter1.string(from: t.date)
				
				let df = DateFormatter()
				df.dateStyle = .full
				var todoDateFormatted = df.string(from: t.date)
				todoDateFormatted.removeLast(6)
				
				todo_name_lbl.text = t.name
				todo_name_lbl.textColor = user.colors[t.color]
				todo_date_lbl.text = "\(todoDateFormatted) • \(tDate)"
				note_txtview.text = t.note
				progress_spinner.stopAnimating()
				more_btn.tag = t.ID.hashValue
				tID = t.ID
				break
			}
		}
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if note_txtview.text == "Add note..." {
			note_txtview.text = ""
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if note_txtview.text == "" {
			note_txtview.text = "Add note..."
		}
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			note_txtview.resignFirstResponder()
			return false
		}
		return true
	}
	
	@IBAction func close_tapped(_ sender: Any) {
		for t in user.todos {
			if t.ID == tID {
				if t.note != note_txtview.text.trimmingCharacters(in: .whitespacesAndNewlines) {
					if note_txtview.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
						db.collection("users").document(user.ID).collection("to-dos").document(tID).updateData([
							"note" : "Add note..."
						])
					} else {
						db.collection("users").document(user.ID).collection("to-dos").document(tID).updateData([
							"note" : note_txtview.text.trimmingCharacters(in: .whitespacesAndNewlines)
						])
					}
					for t in user.todos {
						if t.ID == tID {
							t.note = note_txtview.text.trimmingCharacters(in: .whitespacesAndNewlines)
						}
					}
				}
			}
		}
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func more_tapped(_ sender: Any) {
		for t in user.todos {
			if t.ID == tID {
				if t.note != note_txtview.text.trimmingCharacters(in: .whitespacesAndNewlines) {
					if note_txtview.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
						db.collection("users").document(user.ID).collection("to-dos").document(tID).updateData([
							"note" : "Add note..."
						])
					} else {
						db.collection("users").document(user.ID).collection("to-dos").document(tID).updateData([
							"note" : note_txtview.text.trimmingCharacters(in: .whitespacesAndNewlines)
						])
					}
					for t in user.todos {
						if t.ID == tID {
							t.note = note_txtview.text.trimmingCharacters(in: .whitespacesAndNewlines)
						}
					}
				}
			}
		}
		performSegue(withIdentifier: "edit_todo_segue", sender: sent_tID)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditTodoViewController {
			let v = segue.destination as! EditTodoViewController
			let tid = sender as? Int
			v.sent_tID = tid!
		}
	}
	
}
