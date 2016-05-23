//
//  ConfirmViewController.swift
//  Repay
//
//  Created by Kevin Vincent on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {

    @IBOutlet var categoryText: UILabel!
    @IBOutlet var amount: UILabel!
    @IBOutlet var yaybtn: UIButton!
    
    var lastReceipt: Receipt?
    
    @IBAction func yay(sender: AnyObject) {
        navigationController!.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nConfirmViewController...")

        // Do any additional setup after loading the view.
        navigationController!.setNavigationBarHidden(true,animated: false);
        
        //Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 42/255, green: 183/255, blue:133/255, alpha: 1).CGColor, UIColor.init(red: 0/255, green: 94/255, blue:43/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, below: amount.layer)
        
        // Configuring view fields
        switch (lastReceipt!.category) {
            case "Lodging":
                categoryText.text = "LODGING"
                break;
            case "Transportation":
                categoryText.text = "TRANSPORTATION"
                break;
            default:
                categoryText.text = "FOOD"
                break;
        }
                
        let str = NSString(format: "%.2f", lastReceipt!.requested_amt)
        amount.text = "$" + (str as String)
        yaybtn.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1);
        
        print("Your \(categoryText.text!) request for \(amount.text!) is under review!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
