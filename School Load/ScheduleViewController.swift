//
//  ScheduleViewController.swift
//  School Load
//
//  Created by Dylan Teller on 12/13/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
