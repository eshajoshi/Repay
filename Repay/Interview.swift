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
    dynamic var uid = ""
    dynamic var interviewee: User?
    dynamic var position = ""
    dynamic var company = ""
    dynamic var start_date = NSDate(timeIntervalSince1970: 1)
    dynamic var end_date = NSDate(timeIntervalSince1970: 1)
    dynamic var budgets: Budget?
}
