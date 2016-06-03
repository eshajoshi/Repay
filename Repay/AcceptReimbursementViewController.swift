//
//  AcceptReimbursementViewController.swift
//  Repay
//
//  Created by Esha Joshi on 6/2/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

class AcceptReimbursementViewController: UIViewController {
    @IBOutlet var barBtnBack: UIBarButtonItem!
    @IBOutlet var receiptImage: UIImageView!
    @IBOutlet var date_requested: UILabel!
    @IBOutlet var approved_amt: UILabel!
    @IBOutlet var approved_amt_view: UIView!
    @IBOutlet var new_requested_amt_view: UIView!
    @IBOutlet var new_requested_amt: UILabel!
    @IBOutlet var new_reason_view: UIView!
    @IBOutlet var new_reason: UILabel!
    
    var receiptCell: HistoryTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        print("\nAcceptReimbursementViewController...")
        
        // 'History' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Back' Bar Button Item
        barBtnBack.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnBack.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // Views
        new_requested_amt_view.layer.cornerRadius = 5.0
        approved_amt_view.layer.cornerRadius = 5.0
        new_reason_view.layer.cornerRadius = 5.0
        
        // Labels
        date_requested.sizeToFit()
        date_requested.adjustsFontSizeToFitWidth = true
        approved_amt.sizeToFit()
        approved_amt.adjustsFontSizeToFitWidth = true
        new_requested_amt.sizeToFit()
        new_requested_amt.adjustsFontSizeToFitWidth = true
        new_reason.sizeToFit()
        new_reason.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
