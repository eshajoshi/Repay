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
    
    override func viewDidAppear(animated: Bool) {
        print("tableView.frame: \(tableView.frame)")
        print("pendingReceipts.count: \(pendingReceipts.count)")
        print("completedReceipts.count: \(completedReceipts.count)")
        
        // Reload data
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
    }
     */
    
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

    // Set to pendingReceipts.count + completedReceipts.count + 2 ('Pending' and 'Completed' labels)
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // TODO: Need to change to accommodate self.completedReceipts.count + 1
        return self.pendingReceipts.count + 1
    }

    // Set to one cell for each section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Height for header in section to set space between cells
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Set the header's background color to white color
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.whiteColor()
        return headerView;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Configuring table view cells...")
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        // Aesthetics
        cell.btn.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        cell.btn.layer.cornerRadius = 5
        cell.btn.layer.borderWidth = 0
        cell.category.sizeToFit()
        cell.category.adjustsFontSizeToFitWidth = true
        cell.requested_amt.sizeToFit()
        cell.requested_amt.adjustsFontSizeToFitWidth = true
        cell.date.sizeToFit()
        cell.date.adjustsFontSizeToFitWidth = true
        
        // Content
        cell.category?.text = pendingReceipts[indexPath.row].category
        
        let str = NSString(format: "%.2f", self.pendingReceipts[indexPath.row].requested_amt)
        cell.requested_amt?.text = "$" + (str as String)
        
        cell.date?.text = String(NSDate(timeIntervalSince1970 : (pendingReceipts[indexPath.row].timestamp / 1000)))
        cell.arrowImage?.image = UIImage(named: "forward_arrow")
        
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

}
