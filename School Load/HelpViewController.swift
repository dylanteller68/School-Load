//
//  HelpViewController.swift
//  School Load
//
//  Created by Dylan Teller on 8/9/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
	
	@IBOutlet weak var delete_acct_btn: UIButton!
	@IBOutlet weak var scrollview: UIScrollView!
	
	var isContactScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()
		delete_acct_btn.layer.cornerRadius = 25
		if isContactScreen {
			scrollview.contentOffset = CGPoint(x: 0, y: scrollview.contentSize.height - scrollview.bounds.size.height + scrollview.contentInset.bottom)
		}
    }
	
	@IBAction func delete_acct_tapped(_ sender: Any) {
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if isContactScreen {
			scrollview.contentOffset = CGPoint(x: 0, y: scrollview.contentSize.height - scrollview.bounds.size.height + scrollview.contentInset.bottom)
		}
	}

	@IBAction func cancel_tapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
