//
//  HomeViewController.swift
//  Repay
//
//  Created by Kevin Vincent on 4/9/16.
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
    
    
    @IBOutlet var companyImage: UIImageView!
    @IBOutlet var balanceLabelText: UILabel!
    @IBOutlet weak var companyLabelText: UILabel!

    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var btnHistory: UIButton!


    //------- MODAL STUFF --------

    @IBOutlet var blur: UIVisualEffectView!
    @IBOutlet var modalView: UIView!
    @IBOutlet var btnAirbnb: UIButton!
    @IBOutlet var btnApple: UIButton!
    @IBOutlet var btnGoogle: UIButton!
    
    @IBAction func showModal(sender: AnyObject) {
        modalView.hidden = false
        showBlur()
    }
    

    @IBAction func handleAirbnbClicked(sender: AnyObject) {
        companyLabelText.text = "Airbnb"
        setLogo("airbnb_large");
        hideModal()
        hideBlur()
    }
    @IBAction func handleAppleClicked(sender: AnyObject) {
        companyLabelText.text = "Apple"
        setLogo("apple_large");
        hideModal()
        hideBlur()
    }
    
    @IBAction func handleGoogleClicked(sender: AnyObject) {
        companyLabelText.text = "Google"
        setLogo("google_large");
        hideModal()
        hideBlur()
    }
    
    @IBAction func handleCancelClicked(sender: AnyObject) {

        hideModal()
        hideBlur()
    }
    
    func showModal() {
        modalView.hidden = false;
        UIView.animateWithDuration(0.4,
                                   delay: 0.0,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    self.modalView.alpha = 1
            },
                                   completion: { finished in
                                    print("Bug moved left!")
        })
    }
    
    func hideModal() {
        modalView.hidden = true;
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
    
    // ------ App Stuff -------
    func loadBalance() {
        let longString = "$400.00"
        
        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(80)])
        
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir Next", size: 48.0)!, range: NSRange(location:longString.indexOfCharacter(".")!+1,length:2))
        
        balanceLabelText.attributedText = attributedString
    }
    
    func setLogo(id: String) {
        let image: UIImage = UIImage(named: id)!
        companyImage.image = image;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeModal();
        
        navigationController!.setNavigationBarHidden(true,animated: false);

        //Customize buttons
        btnUpload.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1);
        btnHistory.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1);
        
        //Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 42/255, green: 183/255, blue:133/255, alpha: 1).CGColor, UIColor.init(red: 0/255, green: 94/255, blue:43/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, below: btnUpload.layer)
        
        //Balance Customization
        loadBalance()
        
        //Customize company logo
        setLogo("airbnb_large");
        
        self.modalView.hidden = true;
        hideBlur()
        hideModal()
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
