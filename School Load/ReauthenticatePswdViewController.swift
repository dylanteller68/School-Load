//
//  ReauthenticatePswdViewController.swift
//  School Load
//
//  Created by Dylan Teller on 5/26/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class ReauthenticatePswdViewController: UIViewController {

	@IBOutlet weak var verify_btn: UIButton!
	@IBOutlet weak var email_txtbx: UITextField!
	@IBOutlet weak var password_txtbx: UITextField!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var error_lbl: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		verify_btn.layer.cornerRadius = 25
	}
	
	@IBAction func verify_tapped(_ sender: Any) {
		email_txtbx.resignFirstResponder()
		password_txtbx.resignFirstResponder()
		
		let email = email_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
		let password = password_txtbx.text ?? ""
		
		if email != "" && password != "" {
			
			verify_btn.isEnabled = false
			
			verify_btn.setTitle("", for: .normal)
			progress_spinner.isHidden = false
			progress_spinner.startAnimating()
			
			let cred = EmailAuthProvider.credential(withEmail: email, password: password)
	
			Auth.auth().currentUser?.reauthenticate(with: cred, completion: { (adr, error) in
				if error == nil {
					self.error_lbl.isHidden = true
					self.progress_spinner.stopAnimating()
					self.verify_btn.setTitle("Verified", for: .normal)
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.performSegue(withIdentifier: "edit_password_segue", sender: self)
					}
				} else {
					self.error_lbl.text = "Invalid email/password"
					self.error_lbl.isHidden = false
					self.progress_spinner.stopAnimating()
					self.verify_btn.setTitle("Verify", for: .normal)
					self.verify_btn.isEnabled = true
				}
			})
		} else {
			error_lbl.text = "Email/Password required"
			error_lbl.isHidden = false
			self.verify_btn.isEnabled = true
		}
	}

	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func email_done(_ sender: Any) {
		email_txtbx.resignFirstResponder()
	}

	@IBAction func password_done(_ sender: Any) {
		password_txtbx.resignFirstResponder()
	}
}
