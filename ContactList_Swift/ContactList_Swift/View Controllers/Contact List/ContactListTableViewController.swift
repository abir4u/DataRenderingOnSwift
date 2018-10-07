//
//  ContactListTableViewController.swift
//  ContactList_Swift
//
//  Created by Abir Pal on 11/08/17.
//  Copyright © 2017 Random1. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    var isSortCountOdd: Bool = false
    var contactData = [Dictionary<String, Any>]()
    var contactDetails : [ContactListInfo] = []
    @IBOutlet var tblContactList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        let btnSortNames = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.sortListAlphabetically))
        self.navigationItem.rightBarButtonItem = btnSortNames
        archiveContactInfoFor(contactData.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Contacts"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sortListAlphabetically() {
        if !isSortCountOdd {
            contactDetails.sort() { ($0.name) > ($1.name) }
            isSortCountOdd = true
        }
        else {
            contactDetails.reverse()
            isSortCountOdd = false
        }
        self.tblContactList.reloadData();
    }
    
    func archiveContactInfoFor(_ row: Int) {
        for contactId in 0...(row - 1) {
            let contactListInfo = ContactListInfo(
                contactName: ((self.contactData[contactId])["name"]! as? String)!,
                username: ((self.contactData[contactId])["username"]! as? String)!,
                email: ((self.contactData[contactId])["email"]! as? String)!,
                address: (self.contactData[contactId])["address"] as! [String : Any],
                phone: ((self.contactData[contactId])["phone"]! as? String)!,
                website: ((self.contactData[contactId])["website"]! as? String)!,
                andCompany: (self.contactData[contactId])["company"] as! [String : String])
            contactDetails.append(contactListInfo)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier)
        }
        cell?.textLabel?.text = contactDetails[indexPath.row].name
        cell?.detailTextLabel?.text = contactDetails[indexPath.row].email
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactDetailsViewController = ContactDetailsViewController(nibName: "ContactDetailsViewController", bundle: nil)
        contactDetailsViewController.name = contactDetails[indexPath.row].name
        contactDetailsViewController.username = contactDetails[indexPath.row].username
        contactDetailsViewController.phone = contactDetails[indexPath.row].phone
        contactDetailsViewController.email = contactDetails[indexPath.row].email
        contactDetailsViewController.address = contactDetails[indexPath.row].address
        contactDetailsViewController.website = contactDetails[indexPath.row].website
        contactDetailsViewController.company = contactDetails[indexPath.row].company
        navigationController?.pushViewController(contactDetailsViewController, animated: true)
        title = ""
    }

}
