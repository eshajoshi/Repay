//
//  User.swift
//  Repay
//
//  Created by Esha Joshi on 5/3/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var email = ""
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var temp_password = ""
    dynamic var new_password = ""
    dynamic var confirm_password = ""
}
