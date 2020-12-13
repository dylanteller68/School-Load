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
	
	var btns: [UIStackView] = []
	var btnsText = ["Course Schedule", "Notes", "Study Timer", "GPA Calculator", "My Info", "Help"]
	var btnsImg = ["calendar", "square.and.pencil", "timer", "graduationcap", "person", "questionmark.folder"]

	override func viewDidLoad() {
        super.viewDidLoad()
		
		for i in 0..<6 {
			let icon_btn = UIButton(type: .system)
			icon_btn.setTitle("", for: .normal)
			icon_btn.setBackgroundImage(UIImage(systemName: btnsImg[i], withConfiguration: UIImage.SymbolConfiguration(weight: .thin)), for: .normal)
			if btnsText[i] == "Help" {
				icon_btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
			}
			else {
				icon_btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
			}
			icon_btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
			icon_btn.tintColor = .label
			icon_btn.backgroundColor = .systemGray5
			
			let txt_btn = UIButton(type: .system)
			txt_btn.setTitle(btnsText[i], for: .normal)
			txt_btn.titleLabel?.font = .systemFont(ofSize: 22, weight: .thin)
			txt_btn.setTitleColor(.label, for: .normal)
			txt_btn.titleLabel?.numberOfLines = 2
			txt_btn.titleLabel?.textAlignment = .center
			txt_btn.contentEdgeInsets.left = 30
			txt_btn.contentEdgeInsets.right = 30
			txt_btn.contentEdgeInsets.bottom = 5

			let v = UIView()
			
			let btn = UIStackView(arrangedSubviews: [v, icon_btn, txt_btn])
			btn.axis = .vertical
			btn.alignment = .center
			btn.distribution = .fill
			btn.spacing = 0
			btn.addBackground(color: .systemGray5)
			
			switch i {
			case 0:
				icon_btn.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)
				txt_btn.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)
				let subv = btn.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)
			case 1:
				icon_btn.addTarget(self, action: #selector(self.notes_btn_tapped), for: .touchUpInside)
				txt_btn.addTarget(self, action: #selector(self.notes_btn_tapped), for: .touchUpInside)
				let subv = btn.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.notes_btn_tapped), for: .touchUpInside)
			case 2:
				icon_btn.addTarget(self, action: #selector(self.timer_btn_tapped), for: .touchUpInside)
				txt_btn.addTarget(self, action: #selector(self.timer_btn_tapped), for: .touchUpInside)
				let subv = btn.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.timer_btn_tapped), for: .touchUpInside)
			case 3:
				icon_btn.addTarget(self, action: #selector(self.gpa_btn_tapped), for: .touchUpInside)
				txt_btn.addTarget(self, action: #selector(self.gpa_btn_tapped), for: .touchUpInside)
				let subv = btn.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.gpa_btn_tapped), for: .touchUpInside)
			case 4:
				icon_btn.addTarget(self, action: #selector(self.info_btn_tapped), for: .touchUpInside)
				txt_btn.addTarget(self, action: #selector(self.info_btn_tapped), for: .touchUpInside)
				let subv = btn.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.info_btn_tapped), for: .touchUpInside)
			case 5:
				icon_btn.addTarget(self, action: #selector(self.help_btn_tapped), for: .touchUpInside)
				txt_btn.addTarget(self, action: #selector(self.help_btn_tapped), for: .touchUpInside)
				let subv = btn.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.help_btn_tapped), for: .touchUpInside)
			default:
				icon_btn.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)
				txt_btn.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)
				let subv = btn.subviews[0] as? UIButton
				subv?.addTarget(self, action: #selector(self.schedule_btn_tapped), for: .touchUpInside)
			}
			btns.append(btn)
		}
		
		sv1.addArrangedSubview(btns[0])
		sv1.addArrangedSubview(btns[1])

		sv2.addArrangedSubview(btns[2])
		sv2.addArrangedSubview(btns[3])

		sv3.addArrangedSubview(btns[4])
		sv3.addArrangedSubview(btns[5])
		
		logout_btn.layer.cornerRadius = 25
		logout_btn.titleLabel?.font = .systemFont(ofSize: 30, weight: .thin)
		
		if user.isGuest {
			logout_btn.setTitle("Create Account", for: .normal)
			logout_btn.setTitleColor(.systemGreen, for: .normal)
		} else {
			logout_btn.setTitle("Logout", for: .normal)
			logout_btn.setTitleColor(.systemRed, for: .normal)
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {

		for btn in btns {
			let txt_btn = btn.arrangedSubviews[2] as! UIButton
			let height = txt_btn.frame.size.height

			let v = btn.arrangedSubviews[0] as UIView
			v.heightAnchor.constraint(equalToConstant: height).isActive = true
		}

	}
	
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
