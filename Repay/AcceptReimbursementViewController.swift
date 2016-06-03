//
//  AcceptReimbursementViewController.swift
//  Repay
//
//  Created by Esha Joshi on 6/3/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

class AcceptReimbursementViewController: UIViewController {
    @IBOutlet var amount: UILabel!
    @IBOutlet var yaybtn: UIButton!
    
    var approved_amt: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nAcceptReimbursementViewController...")
        
        // Do any additional setup after loading the view.
        navigationController!.setNavigationBarHidden(true,animated: false);
        
        //Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 42/255, green: 183/255, blue:133/255, alpha: 1).CGColor, UIColor.init(red: 0/255, green: 94/255, blue:43/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, below: amount.layer)

        let str = NSString(format: "%00.2f", approved_amt!)
        amount.text = "$" + (str as String)
        yaybtn.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1);
        
        print("Thank you! \(amount.text!) has been posted to your Venmo account.")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
