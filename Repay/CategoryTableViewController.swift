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
    @IBOutlet var logdingAmt: UILabel!
    @IBOutlet var transportationAmt: UILabel!
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: {
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var foodBalance = 100.00;
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let amt = defaults.stringForKey("amount")
        {

            if(Double(amt) != nil) {
                foodBalance = foodBalance - Double(amt)!;
            }
        }
        
        let s2 = NSString(format: "%.2f", foodBalance)
        let longString2 = "$"+(s2 as String);
        foodAmt.text = longString2;
        
        // 'Select Category' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Cancel' Bar Button Item
        barBtnCancel.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnCancel.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // 'Food' Category
        btnFood.backgroundColor = UIColor.groupTableViewBackgroundColor()
        btnFood.layer.cornerRadius = 5
        btnFood.layer.borderWidth = 0
        
        // 'Lodging' Category
        btnLodging.backgroundColor = UIColor.groupTableViewBackgroundColor()
        btnLodging.layer.cornerRadius = 5
        btnLodging.layer.borderWidth = 0
        
        // 'Transportation' Category
        btnTransp.backgroundColor = UIColor.groupTableViewBackgroundColor()
        btnTransp.layer.cornerRadius = 5
        btnTransp.layer.borderWidth = 0

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
