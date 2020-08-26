//
//  EditPasswordViewController.swift
//  School Load
//
//  Created by Dylan Teller on 5/26/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditPasswordViewController: UIViewController {

	@IBOutlet weak var edit_password_btn: UIButton!
	@IBOutlet weak var password_txtbx: UITextField!
	@IBOutlet weak var error_lbl: UILabel!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var txtbx_constraint_Y: NSLayoutConstraint!
	
	var didTapTxtbx = false

    override func viewDidLoad() {
        super.viewDidLoad()

		edit_password_btn.layer.cornerRadius = 25
		
		if UIDevice().model == "iPad" {
			SV_width_constraint.constant += 100
			btn_width_constraint.constant += 100
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		password_txtbx.becomeFirstResponder()
	}

	@IBAction func edit_password_tapped(_ sender: Any) {
		
		password_txtbx.resignFirstResponder()
		
		let password = password_txtbx.text ?? ""

		if password != "" {
			if password.count >= 8 {
				if validatePassword(password) {
					edit_password_btn.isEnabled = false
					edit_password_btn.setTitle("", for: .normal)
					progress_spinner.startAnimating()
					progress_spinner.isHidden = false
					Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
						self.progress_spinner.stopAnimating()
						if error == nil {
							let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
							notificationFeedbackGenerator.prepare()
							notificationFeedbackGenerator.notificationOccurred(.success)
							
							self.edit_password_btn.setTitle("Password Edited", for: .normal)

							DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
								user.needsToGoToMe = true
								self.dismiss(animated: true, completion: nil)
							}
						}
					})
				} else {
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.error)
					
					error_lbl.text = "Password: at least 1 uppercase,\n lowercase, and number"
					error_lbl.isHidden = false
				}
			} else {
				let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
				notificationFeedbackGenerator.prepare()
				notificationFeedbackGenerator.notificationOccurred(.error)
				
				error_lbl.text = "Password: 8 or more characters"
				error_lbl.isHidden = false
			}
		} else {
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			
			if didTapTxtbx {
				if UIDevice().model == "iPad" {
					txtbx_constraint_Y.constant += 80
				}
				didTapTxtbx = false
			}
			
			error_lbl.text = "Password required"
			error_lbl.isHidden = false
		}
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		user.needsToGoToMe = true
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func txtbx_tapped(_ sender: Any) {
		if !didTapTxtbx {
			if UIDevice().model == "iPad" {
				txtbx_constraint_Y.constant -= 80
			}
			didTapTxtbx = true
		}
	}
	
	@IBAction func password_done(_ sender: Any) {
		password_txtbx.resignFirstResponder()
		if UIDevice().model == "iPad" {
			txtbx_constraint_Y.constant += 80
		}
		didTapTxtbx = false
	}
	
	@IBAction func forgot_password_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	func validatePassword(_ password: String) -> Bool {
		let test = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$")
		return test.evaluate(with: password)
	}
}
