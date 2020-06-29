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
		
		if traitCollection.userInterfaceStyle == .light {
			name_btn.setTitleColor(.black, for: .normal)
			email_btn.setTitleColor(.black, for: .normal)
			change_password_btn.setTitleColor(.black, for: .normal)
			notifications_btn.setTitleColor(.black, for: .normal)
			contact_btn.setTitleColor(.black, for: .normal)
			help_btn.setTitleColor(.black, for: .normal)
			rate_btn.setTitleColor(.black, for: .normal)
		}
		
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
		
		switch UIDevice().model {
		case "iPad":
			switch UIDevice().orientation {
			case .landscapeLeft:
				name_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				email_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				change_password_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				notifications_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				contact_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				help_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				rate_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				logout_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				break
			case .landscapeRight:
				name_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				email_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				change_password_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				notifications_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				contact_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				help_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				rate_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				logout_btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .thin)
				break
			default:
				name_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
				email_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
				change_password_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
				notifications_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
				contact_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
				help_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
				rate_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
				logout_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
				break
			}
		default:
			name_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
			email_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
			change_password_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
			notifications_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
			contact_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
			help_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
			rate_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
			logout_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
			break
		}
		
		name_btn.setTitle("Name: \(name)", for: .normal)
		email_btn.setTitle("Email: \(email)", for: .normal)
		
		name_btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		email_btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    }
	
	override func viewDidAppear(_ animated: Bool) {
		let name = "\(user.fname) \(user.lname)"
		name_btn.setTitle("Name: \(name)", for: .normal)
		
		let email = Auth.auth().currentUser!.email!
		email_btn.setTitle("Email: \(email)", for: .normal)
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
