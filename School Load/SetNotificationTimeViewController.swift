//
//  SetNotificationTimeViewController.swift
//  School Load
//
//  Created by Dylan Teller on 8/10/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class SetNotificationTimeViewController: UIViewController {

	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var next_btn: UIButton!
	
	var fname = ""
	var lname = ""
	var email = ""
	var hour = 0
	var minute = 0
	
	override func viewDidLoad() {
        super.viewDidLoad()

		next_btn.layer.cornerRadius = 25
    }

	@IBAction func next_btn_tapped(_ sender: Any) {
		let date = datePicker.date
		let calendar = Calendar.current

		hour = calendar.component(.hour, from: date)
		minute = calendar.component(.minute, from: date)
		
		performSegue(withIdentifier: "your_password_segue", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is YourPasswordViewController {
			let v = segue.destination as! YourPasswordViewController
			v.fname = fname
			v.lname = lname
			v.email = email
			v.hour = hour
			v.minute = minute
		}
	}
	
	@IBAction func back_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
