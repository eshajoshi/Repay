//
//  HistoryViewController.swift
//  Repay
//
//  Created by Kevin Vincent on 4/8/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var barBtnBack: UIBarButtonItem!
    
    @IBAction func handleBtnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HistoryViewController...")
        
        // 'History' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Back' Bar Button Item
        barBtnBack.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnBack.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

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
