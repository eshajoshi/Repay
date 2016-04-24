//
//  HomeViewController.swift
//  Repay
//
//  Created by Esha Joshi on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

extension String {
    public func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.characters.indexOf(char) {
            return self.startIndex.distanceTo(idx)
        }
        
        return nil
    }
}

class HomeViewController: UIViewController {
    // ------ Modal vars -------
    @IBOutlet var blur: UIVisualEffectView!
    @IBOutlet var modalView: UIView!
    @IBOutlet var btnAirbnb: UIButton!
    @IBOutlet var btnApple: UIButton!
    @IBOutlet var btnGoogle: UIButton!
    
    // ------ App vars -------
    @IBOutlet var companyImage: UIImageView!
    @IBOutlet var balanceLabelText: UILabel!
    @IBOutlet weak var companyLabelText: UILabel!
    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var btnHistory: UIButton!
    @IBOutlet var foodAmt: UILabel!
    @IBOutlet var lodgingAmt: UILabel!
    @IBOutlet var transportationAmt: UILabel!
    
    // ------ Modal functionality -------
    @IBAction func showModal(sender: AnyObject) {
        print("IBAction: Clicked on modal...")
        self.modalView.hidden = false
        UIView.animateWithDuration(0.4,
                                   delay: 0.0,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    self.modalView.alpha = 1
            },
                                   completion: { finished in
                                    print("Bug moved left!")
        })
        
        showBlur()
    }
    
    @IBAction func handleCompanyButtonClicked(sender: AnyObject) {
        let button = sender as! UIButton
        let btnText = button.currentTitle! as String
        
        if btnText != "Cancel" {
            print("Company set to \(btnText).")
            companyLabelText.text = btnText
            setLogo(getCompanyImageLogo(companyLabelText.text!))
        }

        hideModal()
        hideBlur()
    }
    
    func getCompanyImageLogo(company: String) -> String {
        if company == "Airbnb" {
            return "airbnb_large"
        } else if company == "Apple" {
            return "apple_large"
        }
        
        return "google_large"
    }
    
    func hideModal() {
        UIView.animateWithDuration(0.1,
                                   delay: 0.0,
                                   options: .CurveEaseInOut,
                                   animations: {
                                        self.modalView.alpha = 0
                                    },
                                   completion: { finished in
                                        self.modalView.hidden = true;
                                    })
    }
    
    func hideBlur() {
        UIView.animateWithDuration(0.2, animations:{
            self.blur.effect = nil
        }, completion: { (value: Bool) in
            self.blur.hidden = true
        })
    }
    
    func showBlur() {
        self.blur.hidden = false;
        UIView.animateWithDuration(0.2) {
            self.blur.effect = UIBlurEffect(style: .Dark)
        }
    }
    
    func customizeModal() {
        modalView.layer.cornerRadius = 10.0
        modalView.layer.borderWidth = 0
        modalView.clipsToBounds = true
        
        btnAirbnb.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue:229/255, alpha: 1);
        btnAirbnb.layer.cornerRadius = 6.0
        btnAirbnb.layer.borderWidth = 0
        btnAirbnb.clipsToBounds = true
        btnApple.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue:229/255, alpha: 1);
        btnApple.layer.cornerRadius = 6.0
        btnApple.layer.borderWidth = 0
        btnApple.clipsToBounds = true
        btnGoogle.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue:229/255, alpha: 1);
        btnGoogle.layer.cornerRadius = 6.0
        btnGoogle.layer.borderWidth = 0
        btnGoogle.clipsToBounds = true
    }
    
    // ------ App Functionality -------
    func loadBalance() {
        
        var totalBalance = 400.00
        var foodBalance = 100.00
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let amt = defaults.stringForKey("amount") {
            if(Double(amt) != nil) {
                totalBalance = totalBalance - Double(amt)!;
            }
            
            if(Double(amt) != nil) {
                foodBalance = foodBalance - Double(amt)!;
            }
        }
        
        let s = NSString(format: "%.2f", totalBalance)
        let longString = "$"+(s as String);
        
        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(80)])
        
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir Next", size: 48.0)!, range: NSRange(location:longString.indexOfCharacter(".")!+1,length:2))
        
        balanceLabelText.attributedText = attributedString
        
        let s2 = NSString(format: "%.2f", foodBalance)
        let longString2 = "$"+(s2 as String);
        foodAmt.text = longString2;
    }
    
    func setLogo(id: String) {
        let image: UIImage = UIImage(named: id)!
        companyImage.image = image;
    }
    
    override func viewDidAppear(animated: Bool) {
        loadBalance();
    }
    
    // Initial view of Main storyboard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.setNavigationBarHidden(true,animated: false);

        // Customize buttons
        btnUpload.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1);
        btnHistory.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1);
        
        // Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 42/255, green: 183/255, blue:133/255, alpha: 1).CGColor, UIColor.init(red: 0/255, green: 94/255, blue:43/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, below: btnUpload.layer)
        
        // Balance Customization
        loadBalance()
        
        // Customize company logo
        setLogo("airbnb_large");
        
        // Modal
        customizeModal();
        hideBlur()
        self.modalView.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
