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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 'Select Category' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 119/255, green: 53/255, blue: 147/255, alpha: 1)

        // 'Cancel' Bar Button Item
        barBtnCancel.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnCancel.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // 'Food' Category
        btnFood.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        btnFood.layer.cornerRadius = 5
        btnFood.layer.borderWidth = 0
        
        // 'Lodging' Category
        btnLodging.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        btnLodging.layer.cornerRadius = 5
        btnLodging.layer.borderWidth = 0
        
        // 'Transportation' Category
        btnTransp.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
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
