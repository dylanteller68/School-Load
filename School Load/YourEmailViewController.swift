//
//  YourEmailViewController.swift
//  School Load
//
//  Created by Dylan Teller on 7/12/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class YourEmailViewController: UIViewController {
	
	@IBOutlet weak var email_txtbx: UITextField!
	@IBOutlet weak var next_btn: UIButton!
	
	var fname = ""
	var lname = ""
	var email = ""

    override func viewDidLoad() {
        super.viewDidLoad()

		next_btn.layer.cornerRadius = 25
    }
	
	override func viewDidAppear(_ animated: Bool) {
		email_txtbx.becomeFirstResponder()
	}
	
	@IBAction func next_tapped(_ sender: Any) {
		email = email_txtbx.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

		if email != "" {
			email_txtbx.resignFirstResponder()
			
			performSegue(withIdentifier: "set_password_segue", sender: self)
		} else {
			next_btn.isEnabled = false
			
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			
			email_txtbx.text = "Email"
			email_txtbx.textColor = .systemRed
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.email_txtbx.text = ""
				self.email_txtbx.textColor = .label
				self.next_btn.isEnabled = true
			}
		}
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is YourPasswordViewController {
			let v = segue.destination as! YourPasswordViewController
			v.fname = fname
			v.lname = lname
			v.email = email
		}
	}
	
	@IBAction func txtbx_done(_ sender: Any) {
		email_txtbx.resignFirstResponder()
		next_tapped(self)
	}
}
