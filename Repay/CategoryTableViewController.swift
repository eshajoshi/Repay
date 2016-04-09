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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFood.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        btnFood.layer.cornerRadius = 5
        btnFood.layer.borderWidth = 0
        
        btnLodging.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        btnLodging.layer.cornerRadius = 5
        btnLodging.layer.borderWidth = 0
        
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
