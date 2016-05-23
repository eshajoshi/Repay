//
//  Message.swift
//  Repay
//
//  Created by Esha Joshi on 5/22/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    dynamic var message = ""
    
    convenience init(message: String) {
        
        self.init()
        self.message = message
    }
}
