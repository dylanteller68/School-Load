//
//  MeViewController.swift
//  School Load
//
//  Created by Dylan Teller on 4/5/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

class MeViewController: UIViewController {


	@IBOutlet weak var name_btn: UIButton!
	@IBOutlet weak var email_btn: UIButton!
	@IBOutlet weak var change_password_btn: UIButton!
	@IBOutlet weak var notifications_btn: UIButton!
	@IBOutlet weak var contact_btn: UIButton!
	@IBOutlet weak var help_btn: UIButton!
	@IBOutlet weak var rate_btn: UIButton!
	@IBOutlet weak var logout_btn: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		name_btn.layer.cornerRadius = 25
		email_btn.layer.cornerRadius = 25
		change_password_btn.layer.cornerRadius = 25
		notifications_btn.layer.cornerRadius = 25
		contact_btn.layer.cornerRadius = 25
		help_btn.layer.cornerRadius = 25
		rate_btn.layer.cornerRadius = 25
		logout_btn.layer.cornerRadius = 25
		
		let name = "\(user.fname) \(user.lname)"
		let email = Auth.auth().currentUser!.email!
		
		self.name_btn.setTitle("Name: \(name)", for: .normal)
		self.email_btn.setTitle("Email: \(email)", for: .normal)
		
		name_btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		email_btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    }
	
	override func viewDidAppear(_ animated: Bool) {
		let name = "\(user.fname) \(user.lname)"
		self.name_btn.setTitle("Name: \(name)", for: .normal)
		
		let email = Auth.auth().currentUser!.email!
		self.email_btn.setTitle("Email: \(email)", for: .normal)
	}
	
	@IBAction func name_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func email_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func password_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func notifications_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func contact_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func help_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func rate_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func logout_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
		do {
			try Auth.auth().signOut()
			user.todos = []
			performSegue(withIdentifier: "logout_segue", sender: self)
		} catch {
			// error
		}
	}
}
