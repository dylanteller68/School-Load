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

class ToolsViewController: UIViewController {

	@IBOutlet weak var sv1: UIStackView!
	@IBOutlet weak var sv2: UIStackView!
	@IBOutlet weak var sv3: UIStackView!
	@IBOutlet weak var logout_btn: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
//		name_btn.layer.cornerRadius = 25
//		name_btn.titleLabel?.numberOfLines = 2
//		name_btn.titleLabel?.textAlignment = .center
//		email_btn.layer.cornerRadius = 25
//		email_btn.titleLabel?.numberOfLines = 2
//		email_btn.titleLabel?.textAlignment = .center
//		change_password_btn.layer.cornerRadius = 25
//		change_password_btn.titleLabel?.numberOfLines = 2
//		change_password_btn.titleLabel?.textAlignment = .center
		
		let btn1 = UIButton(type: .system)
		btn1.setTitle("", for: .normal)
		btn1.setBackgroundImage(UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
		btn1.tintColor = .label
		btn1.widthAnchor.constraint(equalToConstant: 50).isActive = true
		btn1.heightAnchor.constraint(equalToConstant: 50).isActive = true
		btn1.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		btn1.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)
		
		let btn2 = UIButton(type: .system)
		btn2.setTitle("Course Schedule", for: .normal)
		btn2.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
		btn2.setTitleColor(.label, for: .normal)
		btn2.titleLabel?.numberOfLines = 2
		btn2.titleLabel?.textAlignment = .center
		btn2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
		btn2.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)

		let schedule_btn = UIStackView(arrangedSubviews: [btn1, btn2])
		schedule_btn.axis = .vertical
		schedule_btn.alignment = .center
		schedule_btn.distribution = .fill
		schedule_btn.spacing = 0
		schedule_btn.addBackground(color: .systemGray5)
		let subv1 = schedule_btn.subviews[0] as? UIButton
		subv1?.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)
		
		let btn3 = UIButton(type: .system)
		btn3.setTitle("", for: .normal)
		btn3.setBackgroundImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
		btn3.tintColor = .label
		btn3.widthAnchor.constraint(equalToConstant: 50).isActive = true
		btn3.heightAnchor.constraint(equalToConstant: 50).isActive = true
		btn3.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		btn3.addTarget(self, action: #selector(self.notes_btn_tapped), for: .touchUpInside)
		
		let btn4 = UIButton(type: .system)
		btn4.setTitle("Notes", for: .normal)
		btn4.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
		btn4.setTitleColor(.label, for: .normal)
		btn4.titleLabel?.numberOfLines = 2
		btn4.titleLabel?.textAlignment = .center
		btn4.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
		btn4.addTarget(self, action: #selector(self.notes_btn_tapped), for: .touchUpInside)

		let notes_btn = UIStackView(arrangedSubviews: [btn3, btn4])
		notes_btn.axis = .vertical
		notes_btn.alignment = .center
		notes_btn.distribution = .fill
		notes_btn.spacing = 0
		notes_btn.addBackground(color: .systemGray5)
		let subv2 = notes_btn.subviews[0] as? UIButton
		subv2?.addTarget(self, action: #selector(self.notes_btn_tapped), for: .touchUpInside)
		
		let btn5 = UIButton(type: .system)
		btn5.setTitle("", for: .normal)
		btn5.setBackgroundImage(UIImage(systemName: "timer", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
		btn5.tintColor = .label
		btn5.widthAnchor.constraint(equalToConstant: 50).isActive = true
		btn5.heightAnchor.constraint(equalToConstant: 50).isActive = true
		btn5.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		btn5.addTarget(self, action: #selector(self.timer_btn_tapped), for: .touchUpInside)
		
		let btn6 = UIButton(type: .system)
		btn6.setTitle("Study Timer", for: .normal)
		btn6.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
		btn6.setTitleColor(.label, for: .normal)
		btn6.titleLabel?.numberOfLines = 2
		btn6.titleLabel?.textAlignment = .center
		btn6.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
		btn6.addTarget(self, action: #selector(self.timer_btn_tapped), for: .touchUpInside)

		let timer_btn = UIStackView(arrangedSubviews: [btn5, btn6])
		timer_btn.axis = .vertical
		timer_btn.alignment = .center
		timer_btn.distribution = .fill
		timer_btn.spacing = 0
		timer_btn.addBackground(color: .systemGray5)
		let subv3 = timer_btn.subviews[0] as? UIButton
		subv3?.addTarget(self, action: #selector(self.timer_btn_tapped), for: .touchUpInside)
		
		let btn7 = UIButton(type: .system)
		btn7.setTitle("", for: .normal)
		btn7.setBackgroundImage(UIImage(systemName: "graduationcap", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
		btn7.tintColor = .label
		btn7.widthAnchor.constraint(equalToConstant: 50).isActive = true
		btn7.heightAnchor.constraint(equalToConstant: 50).isActive = true
		btn7.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		btn7.addTarget(self, action: #selector(self.gpa_btn_tapped), for: .touchUpInside)
		
		let btn8 = UIButton(type: .system)
		btn8.setTitle("GPA Calculator", for: .normal)
		btn8.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
		btn8.setTitleColor(.label, for: .normal)
		btn8.titleLabel?.numberOfLines = 2
		btn8.titleLabel?.textAlignment = .center
		btn8.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
		btn8.addTarget(self, action: #selector(self.gpa_btn_tapped), for: .touchUpInside)

		let gpa_btn = UIStackView(arrangedSubviews: [btn7, btn8])
		gpa_btn.axis = .vertical
		gpa_btn.alignment = .center
		gpa_btn.distribution = .fill
		gpa_btn.spacing = 0
		gpa_btn.addBackground(color: .systemGray5)
		let subv4 = gpa_btn.subviews[0] as? UIButton
		subv4?.addTarget(self, action: #selector(self.gpa_btn_tapped), for: .touchUpInside)
		
		let btn9 = UIButton(type: .system)
		btn9.setTitle("", for: .normal)
		btn9.setBackgroundImage(UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
		btn9.tintColor = .label
		btn9.widthAnchor.constraint(equalToConstant: 50).isActive = true
		btn9.heightAnchor.constraint(equalToConstant: 50).isActive = true
		btn9.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		btn9.addTarget(self, action: #selector(self.info_btn_tapped), for: .touchUpInside)
		
		let btn10 = UIButton(type: .system)
		btn10.setTitle("My Info", for: .normal)
		btn10.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
		btn10.setTitleColor(.label, for: .normal)
		btn10.titleLabel?.numberOfLines = 2
		btn10.titleLabel?.textAlignment = .center
		btn10.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
		btn10.addTarget(self, action: #selector(self.info_btn_tapped), for: .touchUpInside)

		let info_btn = UIStackView(arrangedSubviews: [btn9, btn10])
		info_btn.axis = .vertical
		info_btn.alignment = .center
		info_btn.distribution = .fill
		info_btn.spacing = 0
		info_btn.addBackground(color: .systemGray5)
		let subv5 = info_btn.subviews[0] as? UIButton
		subv5?.addTarget(self, action: #selector(self.info_btn_tapped), for: .touchUpInside)
		
		let btn11 = UIButton(type: .system)
		btn11.setTitle("", for: .normal)
		btn11.setBackgroundImage(UIImage(systemName: "questionmark", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
		btn11.tintColor = .label
		btn11.widthAnchor.constraint(equalToConstant: 50).isActive = true
		btn11.heightAnchor.constraint(equalToConstant: 50).isActive = true
		btn11.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		btn11.addTarget(self, action: #selector(self.help_btn_tapped), for: .touchUpInside)
		
		let btn12 = UIButton(type: .system)
		btn12.setTitle("Help", for: .normal)
		btn12.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
		btn12.setTitleColor(.label, for: .normal)
		btn12.titleLabel?.numberOfLines = 2
		btn12.titleLabel?.textAlignment = .center
		btn12.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
		btn12.addTarget(self, action: #selector(self.help_btn_tapped), for: .touchUpInside)

		let help_btn = UIStackView(arrangedSubviews: [btn11, btn12])
		help_btn.axis = .vertical
		help_btn.alignment = .center
		help_btn.distribution = .fill
		help_btn.spacing = 0
		help_btn.addBackground(color: .systemGray5)
		let subv6 = help_btn.subviews[0] as? UIButton
		subv6?.addTarget(self, action: #selector(self.help_btn_tapped), for: .touchUpInside)
		
		sv1.addArrangedSubview(schedule_btn)
		sv1.addArrangedSubview(notes_btn)
		sv2.addArrangedSubview(timer_btn)
		sv2.addArrangedSubview(gpa_btn)
		sv3.addArrangedSubview(info_btn)
		sv3.addArrangedSubview(help_btn)
		
		if UIDevice().model == "iPad" {
//			change_password_btn.setTitle("Change Password", for: .normal)
//			rate_btn.setTitle("Rate Us", for: .normal)
		} else {
//			change_password_btn.setTitle("Change\nPassword", for: .normal)
//			rate_btn.setTitle("Rate\nUs", for: .normal)
		}
//		notifications_btn.layer.cornerRadius = 25
//		contact_btn.layer.cornerRadius = 25
//		help_btn.layer.cornerRadius = 25
//		rate_btn.layer.cornerRadius = 25
//		rate_btn.titleLabel?.numberOfLines = 2
//		rate_btn.titleLabel?.textAlignment = .center
		logout_btn.layer.cornerRadius = 25
		
		let name = "\(user.fname) \(user.lname)"
		let email = Auth.auth().currentUser!.email!
		
//		name_btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
//		email_btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
//		change_password_btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
//		notifications_btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .thin)
//		contact_btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
//		help_btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
//		rate_btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .thin)
		logout_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
			
//		name_btn.setTitle("Name:\n\(name)", for: .normal)
//		email_btn.setTitle("Email:\n\(email)", for: .normal)

//		name_btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//		email_btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		
		if user.isGuest {
//			name_btn.isEnabled = false
//			email_btn.isEnabled = false
//			change_password_btn.isEnabled = false
//			email_btn.setTitle("Email:\nGuest Mode", for: .normal)
			logout_btn.setTitle("Create Account", for: .normal)
			logout_btn.setTitleColor(.systemGreen, for: .normal)
		} else {
//			name_btn.isEnabled = true
//			email_btn.isEnabled = true
//			change_password_btn.isEnabled = true
			logout_btn.setTitle("Logout", for: .normal)
			logout_btn.setTitleColor(.systemRed, for: .normal)
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if traitCollection.userInterfaceStyle == .light {
//			name_btn.setTitleColor(.black, for: .normal)
//			email_btn.setTitleColor(.black, for: .normal)
//			change_password_btn.setTitleColor(.black, for: .normal)
//			notifications_btn.setTitleColor(.black, for: .normal)
//			contact_btn.setTitleColor(.black, for: .normal)
//			help_btn.setTitleColor(.black, for: .normal)
//			rate_btn.setTitleColor(.black, for: .normal)
		} else {
//			name_btn.setTitleColor(.label, for: .normal)
//			email_btn.setTitleColor(.label, for: .normal)
//			change_password_btn.setTitleColor(.label, for: .normal)
//			notifications_btn.setTitleColor(.label, for: .normal)
//			contact_btn.setTitleColor(.label, for: .normal)
//			help_btn.setTitleColor(.label, for: .normal)
//			rate_btn.setTitleColor(.label, for: .normal)
		}
		
		let name = "\(user.fname) \(user.lname)"
//		name_btn.setTitle("Name:\n\(name)", for: .normal)
		
		let email = Auth.auth().currentUser!.email!
		if user.isGuest {
//			email_btn.setTitle("Email:\nGuest Mode", for: .normal)
		} else {
//			email_btn.setTitle("Email:\n\(email)", for: .normal)
		}
	}
	
//	@IBAction func name_tapped(_ sender: Any) {
//		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//		selectionFeedbackGenerator.selectionChanged()
//	}
//
//	@IBAction func email_tapped(_ sender: Any) {
//		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//		selectionFeedbackGenerator.selectionChanged()
//	}
//
//	@IBAction func password_tapped(_ sender: Any) {
//		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//		selectionFeedbackGenerator.selectionChanged()
//	}
//
//	@IBAction func notifications_tapped(_ sender: Any) {
//		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//		selectionFeedbackGenerator.selectionChanged()
//	}
//
//	@IBAction func contact_tapped(_ sender: Any) {
//		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//		selectionFeedbackGenerator.selectionChanged()
//		performSegue(withIdentifier: "contact_segue", sender: true)
//	}
//
//	@IBAction func help_tapped(_ sender: Any) {
//		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//		selectionFeedbackGenerator.selectionChanged()
//	}
//
//	@IBAction func rate_tapped(_ sender: Any) {
//		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//		selectionFeedbackGenerator.selectionChanged()
//
//		SKStoreReviewController.requestReview()
//	}
	
	@objc func schedule_btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
//		performSegue(withIdentifier: "course_todos_segue", sender: sender)
	}
	
	@objc func notes_btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
//		performSegue(withIdentifier: "course_todos_segue", sender: sender)
	}
	
	@objc func timer_btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
//		performSegue(withIdentifier: "course_todos_segue", sender: sender)
	}
	
	@objc func gpa_btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
//		performSegue(withIdentifier: "course_todos_segue", sender: sender)
	}
	
	@objc func info_btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
//		performSegue(withIdentifier: "course_todos_segue", sender: sender)
	}
	
	@objc func help_btn_tapped(sender: UIButton) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
//		performSegue(withIdentifier: "course_todos_segue", sender: sender)
	}
	
	@IBAction func logout_tapped(_ sender: Any) {
		let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
		selectionFeedbackGenerator.selectionChanged()
		
		if !user.isGuest {
			do {
				try Auth.auth().signOut()
				user.todos = []
				performSegue(withIdentifier: "logout_segue", sender: self)
			} catch {
				// error
			}
		} else {
			performSegue(withIdentifier: "create_acct_segue", sender: self)
		}
	}
}

extension UIStackView {
	func addBackground(color: UIColor) {
		let subview = UIButton(frame: bounds)
		subview.backgroundColor = color
		subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		subview.layer.cornerRadius = 25
		insertSubview(subview, at: 0)
	}
}
