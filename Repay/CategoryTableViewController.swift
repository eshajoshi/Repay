//
//  CategoryTableViewController.swift
//  Repay
//
//  Created by Esha Joshi on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    @IBOutlet weak var btnFood: UIButton!
    @IBOutlet weak var btnLodging: UIButton!
    @IBOutlet weak var btnTransp: UIButton!
    @IBOutlet weak var barBtnCancel: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet var foodAmt: UILabel!
    @IBOutlet var lodgingAmt: UILabel!
    @IBOutlet var transportationAmt: UILabel!
    
    var curInterview: Interview?
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: {
            
        })
    }
    
    func loadBalances() {
        // Set amounts set forth by company
        let setFood = (self.curInterview?.company_budget?.food_amount)!
        let setLodging = (self.curInterview?.company_budget?.lodging_amount)!
        let setTransportation = (self.curInterview?.company_budget?.transportation_amount)!
        
        // FOOD Updated Balance
        let remainingFood = setFood - (self.curInterview?.food_consumed)!
        self.foodAmt.text = String(format:"$%.2f", remainingFood)
        
        // LODGING Updated Balance
        let remainingLodging = setLodging - (self.curInterview?.lodging_consumed)!
        self.lodgingAmt.text = String(format:"$%.2f", remainingLodging)
        
        // TRANSPORTATION Updated Balance
        let transportationRemaining = setTransportation - (self.curInterview?.transportation_consumed)!
        self.transportationAmt.text = String(format:"$%.2f", transportationRemaining)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let uploadReceiptVC = segue.destinationViewController as! UploadViewController
        
        uploadReceiptVC.curInterview = self.curInterview
        
        if (segue.identifier == "foodReimbursement") {
            uploadReceiptVC.selectedCategory = "Food"
        } else if (segue.identifier == "lodgingReimbursement") {
            uploadReceiptVC.selectedCategory = "Lodging"
        } else {
            uploadReceiptVC.selectedCategory = "Transportation"
        }
        
        print("Repay app recognizing a... ", segue.identifier!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CategoryTableViewController")
        
        // 'Select Category' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Cancel' Bar Button Item
        barBtnCancel.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnCancel.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // Food Category
        btnFood.backgroundColor = UIColor.groupTableViewBackgroundColor()
        btnFood.layer.cornerRadius = 5
        btnFood.layer.borderWidth = 0
        
        // Lodging Category
        btnLodging.backgroundColor = UIColor.groupTableViewBackgroundColor()
        btnLodging.layer.cornerRadius = 5
        btnLodging.layer.borderWidth = 0
        
        // Transportation Category
        btnTransp.backgroundColor = UIColor.groupTableViewBackgroundColor()
        btnTransp.layer.cornerRadius = 5
        btnTransp.layer.borderWidth = 0

        print("Current interview: ", (curInterview?.uid)!)
        loadBalances()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
