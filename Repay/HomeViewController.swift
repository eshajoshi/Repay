//
//  HomeViewController.swift
//  Repay
//
//  Created by Kevin Vincent on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var companyLabelText: UILabel!

    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var btnHistory: UIButton!

    
    //------- MODAL STUFF --------
    @IBOutlet var btnAirbnb: UIButton!
    @IBOutlet var btnApple: UIButton!
    @IBOutlet var btnGoogle: UIButton!
    
    @IBAction func handleModalClicked(sender: AnyObject) {
        modalView.hidden = false
    }
    
    
    @IBAction func handleAppleClicked(sender: AnyObject) { companyLabelText.text = "Left for Apple Inc"
        modalView.hidden = true
    }
    
    func customizeModal() {
        btnAirbnb.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue:229/255, alpha: 1);
        btnApple.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue:229/255, alpha: 1);
        btnGoogle.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue:229/255, alpha: 1);
    }
    
    // ------ App Stuff -------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeModal();
        
        // Make navigation bar transparent
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        UINavigationBar.appearance().translucent = true
        
        //Change color
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        //Customize buttons
        btnUpload.backgroundColor = UIColor.whiteColor();
        btnHistory.backgroundColor = UIColor.whiteColor();
        
        //Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 175/255, green: 101/255, blue:197/255, alpha: 1).CGColor, UIColor.init(red: 119/255, green: 53/255, blue:147/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, below: btnUpload.layer)
        modalView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
