//
//  Interview.swift
//  Repay
//
//  Created by Esha Joshi on 5/10/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift

class Interview: Object {
    dynamic var uid = ""                        // Unique id for Interview (key in DB)
    dynamic var interviewee_id = ""             // 'user' object uid
    dynamic var position = ""
    dynamic var company = ""
    dynamic var start_date = ""
    dynamic var end_date = ""

//    dynamic var start_date = NSDate(timeIntervalSince1970: 1)
//    dynamic var end_date = NSDate(timeIntervalSince1970: 1)
    dynamic var company_budget: Budget?        // Not in DB
    dynamic var total_balance = 0.0            // Written to DB later
    dynamic var food_balance = 0.0             // Written to DB later
    dynamic var lodging_balance = 0.0          // Written to DB later
    dynamic var transportation_balance = 0.0   // Written to DB later
    
    convenience init(uid: String, interviewee_id : String, position : String, company : String, start_date: String,
                     end_date : String) {
        
        self.init()
        self.uid = uid
        self.interviewee_id = interviewee_id
        self.position = position
        self.company = company
        self.start_date = start_date
        self.end_date = end_date
    }
}
