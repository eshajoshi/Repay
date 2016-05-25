//
//  Image.swift
//  Repay
//
//  Created by Esha Joshi on 5/24/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import Foundation
import RealmSwift

class Image: Object {
    dynamic var uid = ""                       // Unique id for Image
    dynamic var receipt_id = ""              // Receipt object key (Receipt.id)
    dynamic var imageStr = ""
    
    convenience init(uid: String, receipt_id: String, imageStr: String) {
        
        self.init()
        self.uid = uid
        self.receipt_id = receipt_id
        self.imageStr = imageStr
    }
    
    override class func primaryKey() -> String? {
        return "uid"
    }
}
