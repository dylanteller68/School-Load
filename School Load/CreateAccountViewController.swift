//
//  CreateAccountViewController.swift
//  School Load
//
//  Created by Dylan Teller on 3/30/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {

	@IBOutlet weak var fname_txtbx: UITextField!
	@IBOutlet weak var lname_txtbx: UITextField!
	@IBOutlet weak var email_txtbx: UITextField!
	@IBOutlet weak var password_txtbx: UITextField!
	@IBOutlet weak var error_lbl: UILabel!
	@IBOutlet weak var create_account_btn: UIButton!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		error_lbl.isHidden = true
		create_account_btn.layer.cornerRadius = 25
		
		if UIDevice().model == "iPad" {
			btn_width_constraint.constant += 225
			SV_width_constraint.constant += 225
		}
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func create_account_tapped(_ sender: Any) {
		
		let fname = fname_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		let lname = lname_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		let email = email_txtbx.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		let password = password_txtbx.text ?? ""
		
		if fname != "" && lname != "" && email != "" && password != "" {

			fname_txtbx.resignFirstResponder()
			lname_txtbx.resignFirstResponder()
			email_txtbx.resignFirstResponder()
			password_txtbx.resignFirstResponder()

			if password.count >= 8 {
				if validatePassword(password) {
					
					create_account_btn.setTitle("", for: .normal)
					progress_spinner.startAnimating()
					progress_spinner.isHidden = false
					
					Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
						if error != nil {
							self.progress_spinner.stopAnimating()
							
							let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
							notificationFeedbackGenerator.prepare()
							notificationFeedbackGenerator.notificationOccurred(.error)
							
							self.create_account_btn.setTitle("Create Account", for: .normal)
							if error!.localizedDescription == "The email address is badly formatted." {
								self.error_lbl.text = "Invalid email"
							} else if error!.localizedDescription == "The email address is already in use by another account." {
								self.error_lbl.text = "Email already in use"
							} else {
								self.error_lbl.text = "Something went wrong, please try again"
							}
							self.error_lbl.isHidden = false
						} else {
							self.error_lbl.isHidden = true
							let id = authResult?.user.uid ?? ""
							db.collection("users").document(id).setData([
								"first name" : fname,
								"last name" : lname,
								"numCourses" : 0
							])
														
							self.progress_spinner.stopAnimating()
							
							let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
							notificationFeedbackGenerator.prepare()
							notificationFeedbackGenerator.notificationOccurred(.success)
							
							self.create_account_btn.setTitle("Welcome \(fname)", for: .normal)

							DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
								self.performSegue(withIdentifier: "create_and_login_segue", sender: self)
							}
						}
					}
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
			
			error_lbl.text = "All fields required"
			error_lbl.isHidden = false
		}

	}
	
	func validatePassword(_ password: String) -> Bool {
		let test = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$")
		return test.evaluate(with: password)
	}
	
	@IBAction func fname_txtbx_done(_ sender: Any) {
		fname_txtbx.resignFirstResponder()
	}
	
	@IBAction func lname_txtbx_done(_ sender: Any) {
		lname_txtbx.resignFirstResponder()
	}
	
	@IBAction func email_txtbx_done(_ sender: Any) {
		email_txtbx.resignFirstResponder()
	}
	
	@IBAction func password_txtbx_done(_ sender: Any) {
		password_txtbx.resignFirstResponder()
	}
	
}
