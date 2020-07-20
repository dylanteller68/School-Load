//
//  EditEmailViewController.swift
//  School Load
//
//  Created by Dylan Teller on 5/26/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditEmailViewController: UIViewController {

	@IBOutlet weak var email_txtbx: UITextField!
	@IBOutlet weak var edit_email_btn: UIButton!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		edit_email_btn.layer.cornerRadius = 25
		email_txtbx.text = user.email
		
		if UIDevice().model == "iPad" {
			btn_width_constraint.constant += 225
			SV_width_constraint.constant += 225
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		email_txtbx.becomeFirstResponder()
	}

	@IBAction func edit_email_tapped(_ sender: Any) {
		
		email_txtbx.resignFirstResponder()
		
		let email = email_txtbx.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

		if email != "" {
			edit_email_btn.isEnabled = false
			edit_email_btn.setTitle("", for: .normal)
			progress_spinner.startAnimating()
			progress_spinner.isHidden = false
			Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
				self.progress_spinner.stopAnimating()
				if error == nil {
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.success)
					
					self.edit_email_btn.setTitle("Email Edited", for: .normal)

					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						user.needsToGoToMe = true
						self.performSegue(withIdentifier: "edit_email_to_me_segue", sender: self)
					}
				} else {
					// error
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.error)
					
					if error!.localizedDescription == "The email address is badly formatted." {
						self.edit_email_btn.setTitle("Invalid email", for: .normal)
					} else if error!.localizedDescription == "The email address is already in use by another account." {
						self.edit_email_btn.setTitle("Invalid email", for: .normal)
					} else {
						self.edit_email_btn.setTitle("Oops, try again", for: .normal)
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.edit_email_btn.setTitle("Edit Email", for: .normal)
						self.edit_email_btn.isEnabled = true
					}
				}
			})
		} else {
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
		}
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		user.needsToGoToMe = true
		performSegue(withIdentifier: "edit_email_to_me_segue", sender: self)
	}
	
	@IBAction func email_done(_ sender: Any) {
		email_txtbx.resignFirstResponder()
	}
}
