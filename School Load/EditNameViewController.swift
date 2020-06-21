//
//  EditNameViewController.swift
//  School Load
//
//  Created by Dylan Teller on 5/23/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class EditNameViewController: UIViewController {
	
	@IBOutlet weak var name_txtbx: UITextField!
	@IBOutlet weak var editName_btn: UIButton!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	
	var sent_name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

		name_txtbx.text = "\(user.fname) \(user.lname)"
		editName_btn.layer.cornerRadius = 25
		
		if UIDevice().model == "iPad" {
			btn_width_constraint.constant += 225
			SV_width_constraint.constant += 225
		}
    }
	
	@IBAction func edit_name_tapped(_ sender: Any) {
		
		name_txtbx.resignFirstResponder()
		
		let newName = name_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		
		if newName != "" {
			editName_btn.isEnabled = false
			
			name_txtbx.resignFirstResponder()
			
			editName_btn.setTitle("", for: .normal)
			progress_spinner.startAnimating()
			progress_spinner.isHidden = false
			
			var fname = ""
			var lname = ""
			let name = newName.split(separator: " ")
			fname = String(name[0]).trimmingCharacters(in: .whitespacesAndNewlines)
			if name.count == 1 {
				lname = ""
			} else {
				lname = String(name[1]).trimmingCharacters(in: .whitespacesAndNewlines)
			}

			db.collection("users").document(user.ID).updateData([
				"first name" : fname,
				"last name" : lname
			])
			
			user.fname = fname
			user.lname = lname
			
			progress_spinner.stopAnimating()
						
			editName_btn.setTitle("Name Edited", for: .normal)
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.dismiss(animated: true, completion: nil)
			}

		} else {
			
			progress_spinner.stopAnimating()
			name_txtbx.text = "Name"
			name_txtbx.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.name_txtbx.text = ""
				self.name_txtbx.textColor = .label
			}
		}
		
	}
	
	@IBAction func txtbx_done(_ sender: Any) {
		name_txtbx.resignFirstResponder()
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
