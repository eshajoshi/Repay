//
//  Budget.swift
//  Repay
//
//  Created by Esha Joshi on 5/10/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift

class Budget: Object {
    dynamic var company = ""
    dynamic var total_amount = 0.0
    dynamic var food_amount = 0.0
    dynamic var lodging_amount = 0.0
    dynamic var transportation_amount = 0.0
}
