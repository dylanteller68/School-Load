//
//  TodoInfoViewController.swift
//  School Load
//
//  Created by Dylan Teller on 8/11/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class TodoInfoViewController: UIViewController, UITextViewDelegate {

	@IBOutlet weak var note_txtfield: UITextView!
	@IBOutlet weak var todoName_lbl: UILabel!
	@IBOutlet weak var todoDate_lbl: UILabel!
	
	var sent_tid = 0
	var todoID = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()

		for t in user.todos {
			if t.ID.hashValue == sent_tid {
				todoName_lbl.text = t.name
				todoName_lbl.textColor = user.colors[t.color]
				let df = DateFormatter()
				df.dateStyle = .full
				var todoDateFormatted = df.string(from: t.date)
				todoDateFormatted.removeLast(6)
				let formatter1 = DateFormatter()
				formatter1.timeStyle = .short
				let tDate = formatter1.string(from: t.date)
				todoDate_lbl.text = "\(todoDateFormatted), \(tDate)"
				todoDate_lbl.lineBreakMode = .byTruncatingTail
				note_txtfield.text = t.note
				todoID = t.ID
				break
			}
		}
		note_txtfield.layer.cornerRadius = 10
		note_txtfield.delegate = self
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if user.needsToGoToTodos {
			self.dismiss(animated: true, completion: nil)
			user.needsToGoToTodos = false
		}
		
		for t in user.todos {
			if t.ID.hashValue == sent_tid {
				todoName_lbl.text = t.name
				todoName_lbl.textColor = user.colors[t.color]
				let df = DateFormatter()
				df.dateStyle = .full
				var todoDateFormatted = df.string(from: t.date)
				todoDateFormatted.removeLast(6)
				let formatter1 = DateFormatter()
				formatter1.timeStyle = .short
				let tDate = formatter1.string(from: t.date)
				todoDate_lbl.text = "\(todoDateFormatted), \(tDate)"
				note_txtfield.text = t.note
				todoID = t.ID
				break
			}
		}
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		note_txtfield.backgroundColor = .systemGray5
		
		if note_txtfield.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Add note..." {
			note_txtfield.text = ""
		}
	}
	
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
	
	func textViewDidEndEditing(_ textView: UITextView) {
		note_txtfield.backgroundColor = .systemGray6
		
		var note = note_txtfield.text.trimmingCharacters(in: .whitespacesAndNewlines)
		
		if note == "" {
			note = "Add note..."
			note_txtfield.text = note
		}
		
		for t in user.todos {
			if t.ID == todoID {
				if note != t.note {
					db.collection("users").document(user.ID).collection("to-dos").document(todoID).updateData([
						"note" : note
					])
				}
				break
			}
		}
	}

	@IBAction func more_tapped(_ sender: Any) {
		performSegue(withIdentifier: "edit_todo_segue", sender: sent_tid)
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		var note = note_txtfield.text.trimmingCharacters(in: .whitespacesAndNewlines)
		
		if note == "" {
			note = "Add note..."
			note_txtfield.text = note
		}
		
		for t in user.todos {
			if t.ID == todoID {
				if note != t.note {
					db.collection("users").document(user.ID).collection("to-dos").document(todoID).updateData([
						"note" : note
					])
				}
				break
			}
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is EditTodoViewController {
			let v = segue.destination as! EditTodoViewController
			let tid = sender as? Int
			v.sent_tID = tid!
		}
	}
}
