//
//  LoginViewController.swift
//  School Load
//
//  Created by Dylan Teller on 3/31/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
	
	@IBOutlet weak var email_txtbx: UITextField!
	@IBOutlet weak var password_txtbx: UITextField!
	@IBOutlet weak var login_btn: UIButton!
	@IBOutlet weak var create_acct_btn: UIButton!
	@IBOutlet weak var guest_btn: UIButton!
	@IBOutlet weak var forgot_pswd_btn: UIButton!
	@IBOutlet weak var error_lbl: UILabel!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	@IBOutlet weak var SV_width_constraint: NSLayoutConstraint!
	@IBOutlet weak var txtbx_constraint_Y: NSLayoutConstraint!
	@IBOutlet weak var btn_width_constraint: NSLayoutConstraint!
	
	var didTapEmailTxtbx = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		error_lbl.isHidden = true
		login_btn.layer.cornerRadius = 25
		
		if UIDevice().model == "iPad" {
			SV_width_constraint.constant += 100
			btn_width_constraint.constant += 100
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		error_lbl.isHidden = true

		forgot_pswd_btn.isEnabled = true
		create_acct_btn.isEnabled = true
		login_btn.isEnabled = true
		guest_btn.isEnabled = true
		password_txtbx.text = ""
	}

	@IBAction func email_txtbx_done(_ sender: Any) {
		email_txtbx.resignFirstResponder()
		if UIDevice().model == "iPad" {
			txtbx_constraint_Y.constant += 80
		}
		didTapEmailTxtbx = false
	}
	
	@IBAction func password_txtbx_done(_ sender: Any) {
		password_txtbx.resignFirstResponder()
		email_txtbx.resignFirstResponder()
		if UIDevice().model == "iPad" {
			txtbx_constraint_Y.constant += 80
		}
		didTapEmailTxtbx = false
		login_tapped(self)
	}
	
	@IBAction func email_txtbx_tapped(_ sender: Any) {
		if !didTapEmailTxtbx {
			if UIDevice().model == "iPad" {
				txtbx_constraint_Y.constant -= 80
			}
			didTapEmailTxtbx = true
		}
	}
	
	@IBAction func password_txtbx_tapped(_ sender: Any) {
		if !didTapEmailTxtbx {
			if UIDevice().model == "iPad" {
				txtbx_constraint_Y.constant -= 80
			}
			didTapEmailTxtbx = true
		}
	}
	
	@IBAction func login_tapped(_ sender: Any) {
		
		forgot_pswd_btn.isEnabled = false
		create_acct_btn.isEnabled = false
		login_btn.isEnabled = false
		guest_btn.isEnabled = false
		
		email_txtbx.resignFirstResponder()
		password_txtbx.resignFirstResponder()
		
		let email = email_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
		let password = password_txtbx.text ?? ""
		
		if email != "" && password != "" {
			
			login_btn.setTitle("", for: .normal)
			progress_spinner.isHidden = false
			progress_spinner.startAnimating()
			
			Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
				if error != nil {
					let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
					notificationFeedbackGenerator.prepare()
					notificationFeedbackGenerator.notificationOccurred(.error)
					
					self!.error_lbl.text = "Invalid email or password"
					self!.error_lbl.isHidden = false
					self!.progress_spinner.stopAnimating()
					self!.login_btn.setTitle("Login", for: .normal)
				} else {
					self!.error_lbl.isHidden = true
					
					let id = authResult?.user.uid
					let docRef = db.collection("users").document(id!)
					
					var fname = ""

					docRef.getDocument { (document, error) in
						if let document = document, document.exists {
							let data = document.data()
							fname = data!["first name"] as! String
							self!.progress_spinner.stopAnimating()
							
							let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
							notificationFeedbackGenerator.prepare()
							notificationFeedbackGenerator.notificationOccurred(.success)
							
							self!.login_btn.setTitle("Hi \(fname)", for: .normal)
							DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
								self!.performSegue(withIdentifier: "login_segue", sender: self)
							}
						} else {
							//error getting first name
						}
					}
				}
			}
		} else {
			let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
			notificationFeedbackGenerator.prepare()
			notificationFeedbackGenerator.notificationOccurred(.error)
			
			error_lbl.text = "Email & Password required"
			error_lbl.isHidden = false
		}
		
		forgot_pswd_btn.isEnabled = true
		create_acct_btn.isEnabled = true
		login_btn.isEnabled = true
		guest_btn.isEnabled = true
	}
	
	@IBAction func forgot_password_tapped(_ sender: Any) {
		forgot_pswd_btn.isEnabled = false
		create_acct_btn.isEnabled = false
		login_btn.isEnabled = false
		guest_btn.isEnabled = false
		
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func create_account_tapped(_ sender: Any) {
		forgot_pswd_btn.isEnabled = false
		create_acct_btn.isEnabled = false
		login_btn.isEnabled = false
		guest_btn.isEnabled = false
		
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func continue_as_guest_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
		let alert = UIAlertController(title: "Continue as Guest", message: "Without creating an account, you will not be able to access your data on another device.", preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in }))
		alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
			db.collection("users").document().setData([
				"first name" : "Guest",
				"notificationHour" : 0,
				"notificationMinute" : 0
			])
			self.performSegue(withIdentifier: "login_segue", sender: self)
		}))
		alert.popoverPresentationController?.sourceView = guest_btn
		present(alert, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is ForgotPasswordViewController {
			let v = segue.destination as! ForgotPasswordViewController
			let email = email_txtbx.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
			v.sent_email = email
		}
	}
	
}
