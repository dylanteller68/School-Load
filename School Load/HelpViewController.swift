//
//  HelpViewController.swift
//  School Load
//
//  Created by Dylan Teller on 8/9/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import UIKit
import FirebaseAuth

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
		if user.isGuest {
			let alert = UIAlertController(title: "Delete Account", message: "Your account and all data will be permanently deleted. This cannot be undone.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in	}))
			alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
				for t in user.todos {
					db.collection("users").document(user.ID).collection("to-dos").document(t.ID).delete()
				}
				for c in user.courses {
					db.collection("users").document(user.ID).collection("courses").document(c.ID).delete()
				}
				db.collection("users").document(user.ID).delete()
				Auth.auth().currentUser?.delete()
				self.performSegue(withIdentifier: "delete_acct_segue", sender: nil)
			}))
			
			present(alert, animated: true)
		} else {
			performSegue(withIdentifier: "delete_acct_reauth_segue", sender: nil)
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
