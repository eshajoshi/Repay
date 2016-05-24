//
//  HistoryTableViewCell.swift
//  Repay
//
//  Created by Esha Joshi on 5/22/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet var btn: UIButton!
    @IBOutlet var category: UILabel!
    @IBOutlet var requested_amt: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var arrowImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
