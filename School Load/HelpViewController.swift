//
//  HelpViewController.swift
//  School Load
//
//  Created by Dylan Teller on 8/9/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
	
	@IBOutlet weak var scrollview: UIScrollView!
	
	var isContactScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()
		if isContactScreen {
			scrollview.contentOffset = CGPoint(x: 0, y: scrollview.contentSize.height - scrollview.bounds.size.height + scrollview.contentInset.bottom)
		}
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
