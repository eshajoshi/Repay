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
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var barBtnBack: UIBarButtonItem!
    
    var curInterview: Interview?
    var todoReceipts = [Receipt]()
    var flaggedReceipts = [Receipt]()
    var approvedReceipts = [Receipt]()
    
    @IBAction func handleSegmentedControlChange(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    @IBAction func handleBtnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("HistoryTableViewController - viewDidAppear")
        
        segmentedControl.selectedSegmentIndex = 0
        
        // Set default selected segmented control to "Flagged" if any need immediate attention
        if flaggedReceipts.count > 0 {
            segmentedControl.selectedSegmentIndex = 1
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\nHistoryTableViewController...")
        
        print("todo receipts: ", todoReceipts)
        print("flagged receipts: ", flaggedReceipts)
        print("approved receipts: ", approvedReceipts)
        
        // 'History' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Back' Bar Button Item
        barBtnBack.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnBack.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // Segmented Control
        let attr = [NSForegroundColorAttributeName: UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1),
                    NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!]
        segmentedControl.tintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
        
        // Set default selected segmented control to "Flagged"
        segmentedControl.selectedSegmentIndex = 1

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Set to size of list depending on which segmented control index is selected
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // Set to one cell for each section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (segmentedControl.selectedSegmentIndex) {
            case 0:                 // TODO receipts
                return todoReceipts.count
            case 1:                 // FLAGGED receipts
                return flaggedReceipts.count
            case 2:                 // APPROVED receipts
                return approvedReceipts.count
            default:
                return 1
        }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell #\(indexPath.row)")

        let cell = tableView.cellForRowAtIndexPath(indexPath) as! HistoryTableViewCell!
        
        let reimbursementTVC = navigationController?.storyboard?.instantiateViewControllerWithIdentifier("reimbursementTVC") as? ReimbursementTableViewController
        
        reimbursementTVC!.receiptCell = cell
        
        // Push the TableVC into the view hierarachy
        navigationController?.pushViewController(reimbursementTVC!, animated: true)
    }
    
    func getHumanReadableDate(req_date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        return formatter.stringFromDate(req_date)
    }
    
    // Configuring table view cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
        
        // Set content of each cell
        switch (segmentedControl.selectedSegmentIndex) {
            case 0:                 // TODO receipts
                cell.category?.text = self.todoReceipts[indexPath.row].category
                
                let str = NSString(format: "%.2f", self.todoReceipts[indexPath.row].requested_amt)
                cell.requested_amt?.text = "$" + (str as String)
                cell.date?.text = getHumanReadableDate(NSDate(timeIntervalSince1970 : (todoReceipts[indexPath.row].timestamp / 1000)))
                cell.receipt_id = todoReceipts[indexPath.row].id
                cell.status = todoReceipts[indexPath.row].status
                
                break
            case 1:                 // FLAGGED receipts
                cell.category?.text = self.flaggedReceipts[indexPath.row].category
                
                let str = NSString(format: "%.2f", self.flaggedReceipts[indexPath.row].requested_amt)
                cell.requested_amt?.text = "$" + (str as String)
                cell.date?.text = getHumanReadableDate(NSDate(timeIntervalSince1970 : (flaggedReceipts[indexPath.row].timestamp / 1000)))
                cell.receipt_id = self.flaggedReceipts[indexPath.row].id
                cell.status = self.flaggedReceipts[indexPath.row].status
                
                break
            case 2:                 // APPROVED receipts
                cell.category?.text = self.approvedReceipts[indexPath.row].category
                
                let str = NSString(format: "%.2f", self.approvedReceipts[indexPath.row].requested_amt)
                cell.requested_amt?.text = "$" + (str as String)
                cell.date?.text = getHumanReadableDate(NSDate(timeIntervalSince1970 : (approvedReceipts[indexPath.row].timestamp / 1000)))
                cell.receipt_id = self.approvedReceipts[indexPath.row].id
                cell.status = self.approvedReceipts[indexPath.row].status
                
                break
            default:
                break
        }
        
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
