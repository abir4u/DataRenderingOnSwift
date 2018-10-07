//
//  WelcomeViewController.swift
//  ContactList_Swift
//
//  Created by Abir Pal on 12/08/17.
//  Copyright © 2017 Random1. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var contactInfo = [Dictionary<String, Any>]()
    var name = ""
    
    @IBOutlet var loadingContacts: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        self.loadingContacts.startAnimating()
        
        let contactInfoService = ContactInfoService()
        
        contactInfoService.requestContactInfo { (success: Bool, response: URLResponse?, error: Error?) in
            if success {
                self.contactInfo = contactInfoService.contactInfo
                let contactListTableViewController = ContactListTableViewController(nibName: "ContactListTableViewController", bundle: nil)
                contactListTableViewController.contactData = self.contactInfo
                self.loadingContacts.stopAnimating()
                self.navigationController?.pushViewController(contactListTableViewController, animated: false)
            }
            else {
                print("Request Failed")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
