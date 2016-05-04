//
//  RegisteredAppUsers.swift
//  Repay
//
//  Created by Esha Joshi on 5/3/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift

class RegisteredAppUsers: Object {
    dynamic var size = 0
    dynamic var lastAdded: User?
    let users = List<User>()
}
