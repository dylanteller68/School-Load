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
	@IBOutlet weak var error_lbl: UILabel!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		error_lbl.isHidden = true
		login_btn.layer.cornerRadius = 25
	}

	@IBAction func email_txtbx_done(_ sender: Any) {
		email_txtbx.resignFirstResponder()
	}
	
	@IBAction func password_txtbx_done(_ sender: Any) {
		password_txtbx.resignFirstResponder()
	}
	
	@IBAction func login_tapped(_ sender: Any) {
		
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
					self!.error_lbl.text = "Invalid email/password"
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
			error_lbl.text = "Email/Password required"
			error_lbl.isHidden = false
		}
	}
}
