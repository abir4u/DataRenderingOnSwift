//
//  ContactListInfo.swift
//  ContactList_Swift
//
//  Created by Abir Pal on 13/08/17.
//  Copyright © 2017 Random1. All rights reserved.
//

import UIKit

class ContactListInfo: NSObject {
    var name = ""
    var username = ""
    var email = ""
    var address = [String:Any]()
    var phone = ""
    var website = ""
    var company = [String:String]()
    
    init(contactName: String, username: String, email: String, address: Dictionary<String, Any>, phone: String, website: String, andCompany: Dictionary<String, String>) {
        self.name = contactName
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = andCompany
    }
}
