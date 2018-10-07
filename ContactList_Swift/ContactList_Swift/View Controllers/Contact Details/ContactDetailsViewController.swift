//
//  ContactDetailsViewController.swift
//  ContactList_Swift
//
//  Created by Abir Pal on 11/08/17.
//  Copyright © 2017 Random1. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var name = ""
    var username = ""
    var email = ""
    var address = [String:Any]()
    var phone = ""
    var website = ""
    var company = [String:String]()
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblStreet: UILabel!
    @IBOutlet var lblSuite: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblZipCode: UILabel!
    @IBOutlet var lblLatitude: UILabel!
    @IBOutlet var lblLongitude: UILabel!
    @IBOutlet var lblWebsite: UILabel!
    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblCatchphrase: UILabel!
    @IBOutlet var lblBs: UILabel!
    let alert = UIAlertController(title: "Enter Recipient's Mail Id", message: "You can enter multiple emails seperated by a comma (,) followed by a Space ( ). Enter atleast one email address.", preferredStyle: .alert)
    var isMailItTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = name
        lblUsername.text = username
        lblPhone.text = phone
        lblEmail.text = email
        lblStreet.text = address["street"] as? String
        lblSuite.text = address["suite"] as? String
        lblCity.text = address["city"] as? String
        lblZipCode.text = address["zipcode"] as? String
        let geoDict = address["geo"] as! [String : Any]
        lblLatitude.text = geoDict["lat"] as? String
        lblLongitude.text = geoDict["lng"] as? String
        lblWebsite.text = website
        lblCompanyName.text = company["name"]
        lblCatchphrase.text = company["catchPhrase"]
        lblBs.text = company["bs"]
        
        let rightbuttonItemForMail = UIBarButtonItem.init(
            title: "Mail It",
            style: .done,
            target: self,
            action: #selector(btnMailItTapped)
        )

        rightbuttonItemForMail.setTitleTextAttributes([NSFontAttributeName : UIFont.init(name: "KohinoorTelugu-Regular", size: 16.0) as Any, NSForegroundColorAttributeName : UIColor.black], for: UIControlState.normal)
        
        printFonts()
        self.navigationItem.rightBarButtonItem = rightbuttonItemForMail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        isMailItTapped = false
    }
    
    func btnMailItTapped() -> Void {
        let submit = UIAlertAction(title: "Submit", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.isMailItTapped = true
            if (self.alert.textFields?[0].text?.characters.count)! > 0 {
                self.arrangeRecipientEmailsInArrayFrom(stringOfEmails: (self.alert.textFields?[0].text)!)
            }
            else {
                self.btnMailItTapped()
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        if !isMailItTapped {
            alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
                textField.placeholder = " Enter Mail Id"
            })
            alert.addAction(submit)
            alert.addAction(cancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func arrangeRecipientEmailsInArrayFrom(stringOfEmails: String) -> Void {
        var arrayOfEmails = [String]()
        let trimmedStringOfEmails = truncateWhiteSpaceFrom(string: stringOfEmails)
        arrayOfEmails = makeAnArrayOfStringsFrom(mainString: trimmedStringOfEmails, basedOnSeparatorString: ",")
        self.sendMailWithDetails(recipientEmails: arrayOfEmails)
    }
    
    func sendMailWithDetails(recipientEmails: Array<String>) {
        if MFMailComposeViewController.canSendMail()
        {
            let mail = MFMailComposeViewController()
            let street = lblStreet.text
            let suite = lblSuite.text
            let city = lblCity.text
            let zipCode = lblZipCode.text
            let website = lblWebsite.text
            let company = lblCompanyName.text
            let catchphrase = lblCatchphrase.text
            let bs = lblBs.text
            let messageBody = "<html><body><p>Name: <b>" + name + "</b></p><p>Phone: <b>" + phone + "</b></p><p>Phone: <b>" + email + "</b></p><p><b>Address -</b></p><p>Street: <b>" + street! + "</b></p><p>Suite: <b>" + suite! + "</b></p><p>Phone: <b>" + city! + "</b></p><p>Phone: <b>" + zipCode! + "</b></p><p>Phone: <b>" + website! + "</b></p><p><b>Company -</b></p><p>Company Name: <b>" + company! + "</b></p><p>Catchphrase: <b>" + catchphrase! + "</b></p><p>Bs: <b>" + bs! + "</b></p></body>"
            mail.mailComposeDelegate = self
            mail.setSubject("Contact Details for " + name)
            mail.setToRecipients(recipientEmails)
            mail.setMessageBody(messageBody, isHTML: true)
            self.present(mail, animated: true, completion: nil)
        }
        else
        {
            print("This device cannot send email")
            let alert = UIAlertController(title: "", message: "Please set up the Mail app with a valid email Id to be able to share this via mail.", preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(btnOk)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case MFMailComposeResult.sent:
            print("You sent the email.")
            break
        case MFMailComposeResult.saved:
            print("You saved a draft of this email")
            break
        case MFMailComposeResult.cancelled:
            print("You cancelled sending this email.")
            break
        case MFMailComposeResult.failed:
            print("Mail failed:  An error occurred when trying to compose this email")
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /*          ##### WRAPPER METHOD #####
     *truncateWhiteSpaceFrom(string: String) : Trim down any white space within a given String
     *   and returns a String without any Spaces in it.
     ### Parameters : String (with Space)
     ### Return Type: String (without Space)
     */
    func truncateWhiteSpaceFrom(string: String) -> String {
        let trimmedString = string.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    /*          ##### WRAPPER METHOD #####
     *makeAnArrayOfStringsFrom(mainString: String, basedOnSeparatorString: String) : Break down
     *   a String into an Array of sub-strings based on an identifier String. Note that the
     *   identifiers are also eliminated while breaking the string.
     ### Parameters : String (main string to be broken down), String (identifier)
     ### Return Type: Array (of sub-strings)
     */
    func makeAnArrayOfStringsFrom(mainString: String, basedOnSeparatorString: String) -> Array<String> {
        let arrayOfStrings = mainString.components(separatedBy: basedOnSeparatorString)
        return arrayOfStrings
    }
    /*          ##### WRAPPER METHOD #####
     *printFonts() : Animate shaking of textfields/Views.
     ### Parameters : nil
     ### Return Type: nil
     */
    func animateShake() -> Void {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.06
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: (self.alert.textFields?[0].center.x)! - 0.6, y: (self.alert.textFields?[0].center.y)!))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: (self.alert.textFields?[0].center.x)! + 0.6, y: (self.alert.textFields?[0].center.y)!))
        self.alert.textFields?[0].layer.add(shakeAnimation, forKey: "position")
    }
    /*          ##### WRAPPER METHOD #####
     *printFonts() : Print all the fonts supported by Apple currently in Debugger Output.
     ### Parameters : nil
     ### Return Type: nil
     */
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
}
