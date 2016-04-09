//
//  HomeViewController.swift
//  Repay
//
//  Created by Kevin Vincent on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var btnHistory: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let gradientLayer = CAGradientLayer();
        
        gradientLayer.frame = self.view.bounds

        let color1 = UIColor.yellowColor().CGColor as CGColorRef
        let color2 = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.0, 1.0]
        
        // 5
        self.view.layer.addSublayer(gradientLayer)

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
