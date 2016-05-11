//
//  RegisteredInterviews.swift
//  Repay
//
//  Created by Esha Joshi on 5/10/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift

class RegisteredInterviews: Object {
    dynamic var size = 0                // Probably won't need
    dynamic var curInterview: Interview?
    let interviews = List<Interview>()
}
