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
    dynamic var id = ""
    dynamic var interview_id = ""
    dynamic var category = ""
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var position = ""
    dynamic var image = ""
    dynamic var requested_amt = 0.0
    dynamic var status = ""
    dynamic var timestamp = 0.0
    
    convenience init(id: String, interview_id: String, category: String,
                     first_name: String, last_name: String, position: String,
                     image: String, requested_amt: Double, status: String,
                     timestamp: Double) {
        
        self.init()
        self.id = id
        self.interview_id = interview_id
        self.category = category
        self.first_name = first_name
        self.last_name = last_name
        self.position = position
        self.image = image
        self.requested_amt = requested_amt
        self.status = status
        self.timestamp = timestamp
    }
}
