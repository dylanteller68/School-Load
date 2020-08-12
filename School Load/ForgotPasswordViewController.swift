//
//  ForgotPasswordViewController.swift
//  School Load
//
//  Created by Dylan Teller on 4/3/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

	@IBOutlet weak var send_reset_btn: UIButton!
	@IBOutlet weak var email_txtbx: UITextField!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var cancel_btn: UIButton!
	
	var sent_email = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
		send_reset_btn.layer.cornerRadius = 25
		
		email_txtbx.text = sent_email
	}
	
	override func viewDidAppear(_ animated: Bool) {
		email_txtbx.becomeFirstResponder()
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func send_reset_email_tapped(_ sender: Any) {
		
		send_reset_btn.isEnabled = false
		cancel_btn.isEnabled = false
		
		email_txtbx.resignFirstResponder()
		
		let email = email_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
		
		
		if email != "" {
			
			send_reset_btn.setTitle("", for: .normal)
			progress_spinner.startAnimating()
			progress_spinner.isHidden = false
			
			Auth.auth().sendPasswordReset(withEmail: email) { error in
				if error != nil {
					self.progress_spinner.stopAnimating()
					
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.error)
					
					self.send_reset_btn.setTitle("Email not found", for: .normal)
				} else {
					self.progress_spinner.stopAnimating()
					
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.success)
					
					self.send_reset_btn.setTitle("Email Sent", for: .normal)
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.dismiss(animated: true, completion: nil)
					}
				}
			}
		}

		cancel_btn.isEnabled = true
	}
	
	@IBAction func text_changed(_ sender: Any) {
		send_reset_btn.isEnabled = true
		send_reset_btn.setTitle("Send Reset Email", for: .normal)
	}
	
	@IBAction func email_txtbx_done(_ sender: Any) {
		email_txtbx.resignFirstResponder()
		send_reset_email_tapped(self)
	}
}
