//
//  Receipt.swift
//  Repay
//
//  Created by Esha Joshi on 5/3/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift

class Receipt: Object {
    dynamic var category = ""
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var position = ""
    dynamic var id = 0
    dynamic var image = ""
    dynamic var requested_amt = 0.0
    dynamic var status = ""
    dynamic var timestamp = NSDate()
}
