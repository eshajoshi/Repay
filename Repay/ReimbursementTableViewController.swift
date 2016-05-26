//
//  ReimbursementTableViewController.swift
//  Repay
//
//  Created by Esha Joshi on 5/24/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

class ReimbursementTableViewController: UITableViewController {
    @IBOutlet var tabBarView: UIView!
    @IBOutlet var barBtnBack: UIBarButtonItem!
    @IBOutlet var requested_date: UILabel!
    @IBOutlet var requested_amt: UILabel!
    @IBOutlet var requested_amt_view: UIView!
    @IBOutlet var approved_amt: UILabel!
    @IBOutlet var approved_amt_view: UIView!
    @IBOutlet var reason: UILabel!
    @IBOutlet var reason_view: UIView!
    @IBOutlet var receiptImage: UIImageView!
    
    var receiptCell: HistoryTableViewCell?
    
    @IBAction func handleBtnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func convertStrToImageView(image_str: String) -> UIImage {
//        return nil
//    }
    
    func loadTVCFields() {
        print("Loading ReimbursementTVC fields...")
        // Load image
        ref.childByAppendingPath("images").observeEventType(.ChildAdded, withBlock: { snapshot in
            if self.receiptCell?.receipt_id == snapshot.value["receipt_id"] as? String {
//                let image: UIImage = UIImage(imageLiteral: convertStrToImageView((snapshot.value["imageStr"] as? String)!))
//                receiptImage.image = image;
            }
        })
        
        // Load date and requested amount
        requested_date.text = receiptCell?.date.text
        requested_amt.text = receiptCell?.requested_amt.text
        
        // Load approved amount and reason
        let receiptsRef = ref.childByAppendingPath("receipts")
        
        receiptsRef.observeEventType(.Value, withBlock: { snapshot in
            if self.receiptCell?.receipt_id == snapshot.value["receipt_id"] as? String {
                
                let messagesRef = receiptsRef.childByAppendingPath("messages")
                
                messagesRef.observeEventType(.ChildAdded, withBlock: { snapshot in
                    let str = NSString(format: "%.2f", (snapshot.value["approved_amt"] as? String)!)
                    self.approved_amt.text = "$" + (str as String)
                    self.reason.text = snapshot.value["flagged_reason"] as? String
                })
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        loadTVCFields()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nRequestReimbursementTableViewController...")
        
        // 'History' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        print("receiptCell: \((receiptCell?.category.text)!) and \((receiptCell?.requested_amt.text)!)")
        
        // 'Back' Bar Button Item
        barBtnBack.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnBack.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // Views
        requested_amt_view.layer.cornerRadius = 5.0
        approved_amt_view.layer.cornerRadius = 5.0
        reason_view.layer.cornerRadius = 5.0
        
        // Labels
        requested_date.sizeToFit()
        requested_date.adjustsFontSizeToFitWidth = true
        requested_amt.sizeToFit()
        requested_amt.adjustsFontSizeToFitWidth = true
        approved_amt.sizeToFit()
        approved_amt.adjustsFontSizeToFitWidth = true
        reason.sizeToFit()
        reason.adjustsFontSizeToFitWidth = true
        
        loadTVCFields()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
