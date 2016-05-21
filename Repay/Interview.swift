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
    dynamic var company_budget: Budget?         // Not in DB
    dynamic var total_consumed = 0.0            // Written to DB later
    dynamic var food_consumed = 0.0             // Written to DB later
    dynamic var lodging_consumed = 0.0          // Written to DB later
    dynamic var transportation_consumed = 0.0   // Written to DB later
    let receipts = List<Receipt>()
    
    convenience init(uid: String, interviewee_id: String, position: String,
                     company: String, start_date: String, end_date: String,
                     total_consumed: Double, food_consumed: Double, lodging_consumed: Double,
                     transportation_consumed: Double) {
        
        self.init()
        self.uid = uid
        self.interviewee_id = interviewee_id
        self.position = position
        self.company = company
        self.start_date = start_date
        self.end_date = end_date
        self.total_consumed = total_consumed
        self.food_consumed = food_consumed
        self.lodging_consumed = lodging_consumed
        self.transportation_consumed = transportation_consumed
    }
}
