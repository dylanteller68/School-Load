//
//  MeViewController.swift
//  School Load
//
//  Created by Dylan Teller on 4/5/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth
import StoreKit

class MeViewController: UIViewController {


	@IBOutlet weak var name_btn: UIButton!
	@IBOutlet weak var email_btn: UIButton!
	@IBOutlet weak var change_password_btn: UIButton!
//	@IBOutlet weak var notifications_btn: UIButton!
	@IBOutlet weak var contact_btn: UIButton!
	@IBOutlet weak var help_btn: UIButton!
	@IBOutlet weak var rate_btn: UIButton!
	@IBOutlet weak var logout_btn: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		name_btn.layer.cornerRadius = 25
		name_btn.titleLabel?.numberOfLines = 2
		name_btn.titleLabel?.textAlignment = .center
		email_btn.layer.cornerRadius = 25
		email_btn.titleLabel?.numberOfLines = 2
		email_btn.titleLabel?.textAlignment = .center
		change_password_btn.layer.cornerRadius = 25
		change_password_btn.titleLabel?.numberOfLines = 2
		change_password_btn.titleLabel?.textAlignment = .center
		if UIDevice().model == "iPad" {
			change_password_btn.setTitle("Change Password", for: .normal)
			rate_btn.setTitle("Rate Us", for: .normal)
		} else {
			change_password_btn.setTitle("Change\nPassword", for: .normal)
			rate_btn.setTitle("Rate\nUs", for: .normal)
		}
//		notifications_btn.layer.cornerRadius = 25
		contact_btn.layer.cornerRadius = 25
		help_btn.layer.cornerRadius = 25
		rate_btn.layer.cornerRadius = 25
		rate_btn.titleLabel?.numberOfLines = 2
		rate_btn.titleLabel?.textAlignment = .center
		logout_btn.layer.cornerRadius = 25
		
		let name = "\(user.fname) \(user.lname)"
		let email = Auth.auth().currentUser!.email!
		
		name_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
		email_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
		change_password_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
//		notifications_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
		contact_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
		help_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
		rate_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
		logout_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
			
		name_btn.setTitle("Name:\n\(name)", for: .normal)
		email_btn.setTitle("Email:\n\(email)", for: .normal)
		
		name_btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		email_btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		
		if user.isGuest {
			name_btn.isEnabled = false
			email_btn.isEnabled = false
			change_password_btn.isEnabled = false
			email_btn.setTitle("Email:\nGuest Mode", for: .normal)
		} else {
			name_btn.isEnabled = true
			email_btn.isEnabled = true
			change_password_btn.isEnabled = true
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if traitCollection.userInterfaceStyle == .light {
			name_btn.setTitleColor(.black, for: .normal)
			email_btn.setTitleColor(.black, for: .normal)
			change_password_btn.setTitleColor(.black, for: .normal)
//			notifications_btn.setTitleColor(.black, for: .normal)
			contact_btn.setTitleColor(.black, for: .normal)
			help_btn.setTitleColor(.black, for: .normal)
			rate_btn.setTitleColor(.black, for: .normal)
		} else {
			name_btn.setTitleColor(.systemTeal, for: .normal)
			email_btn.setTitleColor(.systemTeal, for: .normal)
			change_password_btn.setTitleColor(.systemTeal, for: .normal)
//			notifications_btn.setTitleColor(.systemTeal, for: .normal)
			contact_btn.setTitleColor(.systemTeal, for: .normal)
			help_btn.setTitleColor(.systemTeal, for: .normal)
			rate_btn.setTitleColor(.systemTeal, for: .normal)
		}
		
		let name = "\(user.fname) \(user.lname)"
		name_btn.setTitle("Name:\n\(name)", for: .normal)
		
		let email = Auth.auth().currentUser!.email!
		if user.isGuest {
			email_btn.setTitle("Email:\nGuest Mode", for: .normal)
		} else {
			email_btn.setTitle("Email:\n\(email)", for: .normal)
		}
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
		performSegue(withIdentifier: "contact_segue", sender: true)
	}
	
	@IBAction func help_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
	}
	
	@IBAction func rate_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
		SKStoreReviewController.requestReview()
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is HelpViewController {
			let v = segue.destination as! HelpViewController
			v.isContactScreen = sender as? Bool ?? false
		}
	}
}
