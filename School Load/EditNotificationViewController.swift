//
//  EditNotificationViewController.swift
//  School Load
//
//  Created by Dylan Teller on 8/10/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class EditNotificationViewController: UIViewController {

	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var edit_btn: UIButton!
	@IBOutlet weak var progress_spinner: UIActivityIndicatorView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		edit_btn.layer.cornerRadius = 25
    }

	@IBAction func edit_notification_tapped(_ sender: Any) {
		progress_spinner.startAnimating()
		edit_btn.setTitle("", for: .normal)
		progress_spinner.isHidden = false
		
		let date = datePicker.date
		let calendar = Calendar.current

		let hour = calendar.component(.hour, from: date)
		let minute = calendar.component(.minute, from: date)
		
		db.collection("users").document(user.ID).updateData([
			"notificationHour" : hour,
			"notificationMinute" : minute
		]) { (error) in
			if error == nil {
				user.notificationHour = hour
				user.notificationMinute = minute
				user.setNotifications()
				self.progress_spinner.stopAnimating()
				self.edit_btn.setTitle("Time Edited", for: .normal)
				let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
				notificationFeedbackGenerator.prepare()
				notificationFeedbackGenerator.notificationOccurred(.success)
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					self.dismiss(animated: true, completion: nil)
				}
			} else {
				let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
				notificationFeedbackGenerator.prepare()
				notificationFeedbackGenerator.notificationOccurred(.error)
				
				self.progress_spinner.stopAnimating()
				self.edit_btn.setTitle("Edit Notifications", for: .normal)
			}
		}
	}
	
	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
