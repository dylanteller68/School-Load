//
//  YourNameViewController.swift
//  School Load
//
//  Created by Dylan Teller on 7/12/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class YourNameViewController: UIViewController {
	
	@IBOutlet weak var next_btn: UIButton!
	@IBOutlet weak var name_txtbx: UITextField!
	@IBOutlet weak var txtbx_constraint_Y: NSLayoutConstraint!
	@IBOutlet weak var txtbx_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	
	var fname = ""
	var lname = ""
	var didTapTxtbx = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

		next_btn.layer.cornerRadius = 25
		txtbx_width_constraint.constant += 100
		btn_width_constraint.constant += 100
	}
	
	override func viewDidAppear(_ animated: Bool) {
		name_txtbx.becomeFirstResponder()
	}

	@IBAction func next_tapped(_ sender: Any) {
		let newName = name_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		
		if newName != "" {
			name_txtbx.resignFirstResponder()
			
			let name = newName.split(separator: " ")
			fname = String(name[0]).trimmingCharacters(in: .whitespacesAndNewlines)
			if name.count == 1 {
				lname = ""
			} else {
				lname = String(name[1]).trimmingCharacters(in: .whitespacesAndNewlines)
			}
			
			performSegue(withIdentifier: "your_email_segue", sender: self)
		} else {
			next_btn.isEnabled = false
			
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			
			name_txtbx.text = "Name"
			name_txtbx.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.name_txtbx.text = ""
				self.name_txtbx.textColor = .label
				self.next_btn.isEnabled = true
			}
		}
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is YourEmailViewController {
			let v = segue.destination as! YourEmailViewController
			v.fname = fname
			v.lname = lname
		}
	}
	
	@IBAction func txtbx_tapped(_ sender: Any) {
		if !didTapTxtbx {
			if UIDevice().model == "iPad" {
				txtbx_constraint_Y.constant -= 80
			}
			didTapTxtbx = true
		}
	}
	
	@IBAction func txtbx_done(_ sender: Any) {
		name_txtbx.resignFirstResponder()
		if UIDevice().model == "iPad" {
			txtbx_constraint_Y.constant += 80
		}
		didTapTxtbx = false
		next_tapped(self)
	}
}
