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
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet var disputeBtn: UIButton!
    
    var receiptCell: HistoryTableViewCell?
    
    @IBAction func handleAcceptBtn(sender: AnyObject) {
        print("Pressed the 'Accept' btn.")
        performSegueWithIdentifier("acceptReimbursementSegue", sender: self)
    }
    
    @IBAction func handleDisputeBtn(sender: AnyObject) {
        print("Pressed the 'Dispute' btn.")
        performSegueWithIdentifier("disputeReimbursementSegue", sender: self)
    }
    
    @IBAction func handleBtnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func retrieveReceiptImage(encodedImageData: String) -> UIImage {
        print("Retrieving UIImage from encoded image data...")
        
        let imageData = NSData(base64EncodedString: encodedImageData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedimage = UIImage(data: imageData!)!
        
        return decodedimage
    }
    
    func loadTVCFields() {
        print("Loading ReimbursementTVC fields...")
        
        // Load image
        ref.childByAppendingPath("images").observeEventType(.ChildAdded, withBlock: { snapshot in
            if self.receiptCell?.receipt_id == snapshot.value["receipt_id"] as? String {                
                self.receiptImage.image = self.retrieveReceiptImage(snapshot.value["imageStr"] as! String)
            }
        })
        
        // Load date and requested amount
        requested_date.text = receiptCell?.date.text
        requested_amt.text = receiptCell?.requested_amt.text
        
        // Load approved amount and reason
        if (receiptCell?.status == "flagged") {
            let receiptsRef = ref.childByAppendingPath("receipts")
            
            receiptsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
                if self.receiptCell?.receipt_id == snapshot.value["id"] as? String {
                    
                    let messagesRef = receiptsRef.childByAppendingPath(snapshot.key + "/messages")
                    
                    messagesRef.queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
                        let str = NSString(format: "%.2f", (Float((snapshot.value["approved_amt"] as? Int)!)))
                        self.approved_amt.text = "$" + (str as String)
                        self.reason.text = snapshot.value["flagged_reason"] as? String
                    })
                }
            })
        } else if (receiptCell?.status == "approved") {
            self.approved_amt.text = requested_amt.text
            self.reason.text = "N/A"
        } else {                // Todo
            self.approved_amt.text = "Pending..."
            self.reason.text = "N/A"
        }
    }
    
    func loadButtons() {
        acceptBtn.frame = CGRectMake(acceptBtn.frame.origin.x, acceptBtn.frame.origin.y, acceptBtn.frame.size.width, acceptBtn.frame.size.height + 20)
        
        disputeBtn.frame = CGRectMake(disputeBtn.frame.origin.x, disputeBtn.frame.origin.y, disputeBtn.frame.size.width, disputeBtn.frame.size.height + 20)
        
        if (receiptCell?.status == "approved" || receiptCell?.status == "todo") {
            acceptBtn.hidden = true
            disputeBtn.hidden = true
        } else {
            acceptBtn.hidden = false
            disputeBtn.hidden = false

            acceptBtn.tintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
            disputeBtn.tintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "acceptReimbursementSegue") {
            let navVC = segue.destinationViewController as! UINavigationController
            let acceptReimbursementVC = navVC.viewControllers.first as! AcceptReimbursementViewController
            
            acceptReimbursementVC.approved_amt = approved_amt.text
        } else if (segue.identifier == "disputeReimbursementSegue") {
            let navVC = segue.destinationViewController as! UINavigationController
            let disputeReimbursementTVC = navVC.topViewController as! DisputeReimbursementTableViewController
            
            disputeReimbursementTVC.image = receiptImage.image
            disputeReimbursementTVC.approved_amt_str = approved_amt.text
            disputeReimbursementTVC.receiptCell = receiptCell
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        loadTVCFields()
        loadButtons()
        
        self.navigationController!.toolbarHidden = false;
        self.navigationController!.toolbar.frame.size.height = 60
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nRequestReimbursementTableViewController...")
        
        // 'History' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
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
        loadButtons()
        
        self.navigationController!.toolbarHidden = false;
        self.navigationController!.toolbar.frame.size.height = 60
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
