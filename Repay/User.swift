//
//  User.swift
//  Repay
//
//  Created by Esha Joshi on 5/3/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class User: Object {
    dynamic var uid = ""
    dynamic var email = ""
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var temp_password = ""
    dynamic var new_password = ""
    dynamic var confirm_password = ""
    
    convenience init(uid: String, email: String, first_name : String, last_name : String, temp_password: String) {
        self.init()
        self.uid = uid
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.temp_password = temp_password
    }
    
    convenience init(uid: String, email: String, first_name : String, last_name : String,
         temp_password: String, new_password : String, confirm_password : String) {
        
        self.init()
        self.uid = uid
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.temp_password = temp_password
        self.new_password = new_password
        self.confirm_password = confirm_password
    }
}