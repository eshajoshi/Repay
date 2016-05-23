//
//  HistoryTableViewController.swift
//  Repay
//
//  Created by Esha Joshi on 5/22/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

class HistoryTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    @IBOutlet var barBtnBack: UIBarButtonItem!
    
    var curInterview: Interview?
    var pendingReceipts = [Receipt]()
    var completedReceipts = [Receipt]()
    
    @IBAction func handleBtnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func readReceiptsFromFirebase(interviewId: String) {
        print("Reading/sorting receipts from Firebase by interview_id: \(interviewId)...")
        
        ref.childByAppendingPath("receipts").observeEventType(.ChildAdded, withBlock: { snapshot in
            if interviewId == snapshot.value["interview_id"] as! String {
                print("\tid: \(snapshot.value["id"])")
                print("\trequested_amt: \(snapshot.value["requested_amt"])!")
                
                let status = snapshot.value["status"] as! String
                
                if status == "approved" {           // No longer needs attention
                    self.completedReceipts.append(self.convertSnapshotToReceipt(snapshot))
                } else {                            // Needed to be looked over by HR or accepted/disputed by interviewee
                    self.pendingReceipts.append(self.convertSnapshotToReceipt(snapshot))
                }
            }
        })
    }
    
    func convertSnapshotToReceipt(snapshot: FDataSnapshot) -> (Receipt) {
        print("Converting snapshot data to a Receipt object...")
        
        return Receipt(id: snapshot.value["id"] as! String,
                    interview_id: snapshot.value["interview_id"] as! String,
                    category: snapshot.value["category"] as! String,
                    first_name: snapshot.value["first_name"] as! String,
                    last_name: snapshot.value["last_name"] as! String,
                    position: snapshot.value["position"] as! String,
                    image: snapshot.value["image"] as! String,
                    requested_amt: snapshot.value["requested_amt"] as! Double,
                    status: snapshot.value["status"] as! String,
                    timestamp: snapshot.value["timestamp"] as! Double)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("tableView.frame: \(tableView.frame)")
        
        self.readReceiptsFromFirebase((self.curInterview?.uid)!)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 35 * Int64(NSEC_PER_SEC))
        
        // Execute code with a delay
        dispatch_after(time, dispatch_get_main_queue()) {
            print("pendingReceipts.count: \(self.pendingReceipts.count)")
            
            for item in self.pendingReceipts {
                print("\t interview_id: \(item.interview_id)")
            }
            
            // Reload data
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\nHistoryTableViewController...")
        
        // 'History' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Back' Bar Button Item
        barBtnBack.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnBack.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 'Pending' and 'Completed' interviews section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pendingReceipts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Configuring table view cells...")
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        // Aesthetics
        cell.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0
            
        // Content
        cell.category?.text = pendingReceipts[indexPath.row].category
        cell.requested_amt?.text = "$" + String(self.pendingReceipts[indexPath.row].requested_amt)
        cell.date?.text = String(pendingReceipts[indexPath.row].timestamp)
        cell.arrowImage?.image = UIImage(named: "forward_arrow")
            
        print("cell.category.text: \(cell.category.text)")
        print("cell.requested_amt.text: \(cell.requested_amt.text)")
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
