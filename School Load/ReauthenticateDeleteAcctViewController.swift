//
//  ReauthenticateDeleteAcctViewController.swift
//  School Load
//
//  Created by Dylan Teller on 8/9/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class ReauthenticateDeleteAcctViewController: UIViewController {

	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var email_txtbx: UITextField!
	@IBOutlet weak var password_txtbx: UITextField!
	@IBOutlet weak var error_lbl: UILabel!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var verify_btn: UIButton!
	@IBOutlet weak var txtbx_constraint_Y: NSLayoutConstraint!
	
	var didTapEmailTxtbx = false
	
	override func viewDidLoad() {
        super.viewDidLoad()

		verify_btn.layer.cornerRadius = 25
		
		if UIDevice().model == "iPad" {
			SV_width_constraint.constant += 100
			btn_width_constraint.constant += 100
		}
    }

	override func viewDidAppear(_ animated: Bool) {
		email_txtbx.becomeFirstResponder()
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
					
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.success)
					
					self.verify_btn.setTitle("Verified", for: .normal)
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.alert_delete()
					}
				} else {
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.error)
					
					self.error_lbl.text = "Invalid email/password"
					self.error_lbl.isHidden = false
					self.progress_spinner.stopAnimating()
					self.verify_btn.setTitle("Verify", for: .normal)
					self.verify_btn.isEnabled = true
				}
			})
		} else {
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			
			if didTapEmailTxtbx {
				if UIDevice().model == "iPad" {
					txtbx_constraint_Y.constant += 80
				}
				didTapEmailTxtbx = false
			}
			
			error_lbl.text = "Email/Password required"
			error_lbl.isHidden = false
			self.verify_btn.isEnabled = true
		}
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func password_done(_ sender: Any) {
		password_txtbx.resignFirstResponder()
		email_txtbx.resignFirstResponder()
		if UIDevice().model == "iPad" {
			txtbx_constraint_Y.constant += 100
		}
		didTapEmailTxtbx = false
		verify_tapped(self)
	}
	
	@IBAction func forgot_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func email_done(_ sender: Any) {
		email_txtbx.resignFirstResponder()
		if UIDevice().model == "iPad" {
			txtbx_constraint_Y.constant += 100
		}
		didTapEmailTxtbx = false
	}
	
	@IBAction func email_txtbx_tapped(_ sender: Any) {
		if !didTapEmailTxtbx {
			if UIDevice().model == "iPad" {
				txtbx_constraint_Y.constant -= 100
			}
			didTapEmailTxtbx = true
		}
	}
	
	@IBAction func password_txtbx_tapped(_ sender: Any) {
		if !didTapEmailTxtbx {
			if UIDevice().model == "iPad" {
				txtbx_constraint_Y.constant -= 100
			}
			didTapEmailTxtbx = true
		}
	}
	
	func alert_delete() {
		let alert = UIAlertController(title: "Delete Account", message: "Your account and all data will be permanently deleted. This cannot be undone.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in	}))
		alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
			for t in user.todos {
				db.collection("users").document(user.ID).collection("to-dos").document(t.ID).delete()
			}
			for c in user.courses {
				db.collection("users").document(user.ID).collection("courses").document(c.ID).delete()
			}
			db.collection("users").document(user.ID).delete()
			Auth.auth().currentUser?.delete()
			self.performSegue(withIdentifier: "delete_acct_segue", sender: nil)
		}))
		
		present(alert, animated: true)
	}
}
