//
//  ContactInfoService.swift
//  ContactList_Swift
//
//  Created by Abir Pal on 12/08/17.
//  Copyright © 2017 Random1. All rights reserved.
//

import UIKit

class ContactInfoService: NSObject {
    
    var contactInfo = [Dictionary<String, Any>]()

    func requestContactInfo(completion: @escaping (_ success: Bool, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = NSURL(string: "https://jsonplaceholder.typicode.com/users")
        
        if url != nil {
            let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        if let object = json as? [Any] {
                            self.contactInfo = object as! [Dictionary<String, Any>]
                            completion(true, response, nil)
                        } else {
                            print("JSON is invalid")
                            completion(false, response, error)
                        }
                    }
                    catch {
                        print("Exception caught in performing JSON Serialization of the response.")
                        print(error.localizedDescription)
                    }
                }
                else {
                    print("Error response received")
                    print(error?.localizedDescription as Any)
                    completion(false, response, error)
                }
            })
            task.resume()
        }
    }
}
