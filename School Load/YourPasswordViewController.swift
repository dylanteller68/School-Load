//
//  YourPasswordViewController.swift
//  School Load
//
//  Created by Dylan Teller on 7/12/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class YourPasswordViewController: UIViewController {
	
	@IBOutlet weak var pswd_txtbx: UITextField!
	@IBOutlet weak var create_acct_btn: UIButton!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var error_lbl: UILabel!
	@IBOutlet weak var cancel_btn: UIButton!
	
	var fname = ""
	var lname = ""
	var email = ""
	var hour = 0
	var minute = 0

    override func viewDidLoad() {
        super.viewDidLoad()

		create_acct_btn.layer.cornerRadius = 25
    }
	
	override func viewDidAppear(_ animated: Bool) {
		pswd_txtbx.becomeFirstResponder()
	}

	@IBAction func create_acct_tapped(_ sender: Any) {
		
		error_lbl.isHidden = true
		
		create_acct_btn.isEnabled = false
		cancel_btn.isEnabled = false
		
		let password = pswd_txtbx.text ?? ""

		if password != "" {
			pswd_txtbx.resignFirstResponder()
			
			if password.count >= 8 {
				if validatePassword(password) {
					
					create_acct_btn.setTitle("", for: .normal)
					progress_spinner.startAnimating()
					progress_spinner.isHidden = false
					
					Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
						if error != nil {
							self.progress_spinner.stopAnimating()
							
							let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
							notificationFeedbackGenerator.prepare()
							notificationFeedbackGenerator.notificationOccurred(.error)
							
							if error!.localizedDescription == "The email address is badly formatted." {
								self.create_acct_btn.setTitle("Invalid email", for: .normal)
							} else if error!.localizedDescription == "The email address is already in use by another account." {
								self.create_acct_btn.setTitle("Invalid email", for: .normal)
							} else {
								self.create_acct_btn.setTitle("Oops, try again", for: .normal)
							}
						} else {
							let id = authResult?.user.uid ?? ""
							if self.lname == "" {
								db.collection("users").document(id).setData([
									"first name" : self.fname,
									"numCourses" : 0,
									"notificationHour" : self.hour,
									"notificationMinute" : self.minute
								])
							} else {
								db.collection("users").document(id).setData([
									"first name" : self.fname,
									"last name" : self.lname,
									"numCourses" : 0,
									"notificationHour" : self.hour,
									"notificationMinute" : self.minute
								])
							}
							
							Auth.auth().currentUser?.sendEmailVerification()
														
							self.progress_spinner.stopAnimating()
							
							let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
							notificationFeedbackGenerator.prepare()
							notificationFeedbackGenerator.notificationOccurred(.success)
							
							self.create_acct_btn.setTitle("Welcome \(self.fname)", for: .normal)

							DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
								self.performSegue(withIdentifier: "create_acct_segue", sender: self)
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
		}
		
		create_acct_btn.isEnabled = true
		cancel_btn.isEnabled = true
	}
	
	@IBAction func txtbx_done(_ sender: Any) {
		pswd_txtbx.resignFirstResponder()
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func validatePassword(_ password: String) -> Bool {
		let test = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$")
		return test.evaluate(with: password)
	}
}
