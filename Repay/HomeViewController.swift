//
//  HomeViewController.swift
//  Repay
//
//  Created by Esha Joshi on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

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
    @IBOutlet var companyBtn1: UIButton!
    @IBOutlet var companyBtn2: UIButton!
    @IBOutlet var companyBtn3: UIButton!
    @IBOutlet var company1Logo: UIImageView!
    @IBOutlet var company2Logo: UIImageView!
    @IBOutlet var company3Logo: UIImageView!
    
    // ------ App vars -------
    @IBOutlet var companyImage: UIImageView!
    @IBOutlet var balanceLabelText: UILabel!
    @IBOutlet weak var companyLabelText: UILabel!
    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var btnHistory: UIButton!
    @IBOutlet var foodAmt: UILabel!
    @IBOutlet var lodgingAmt: UILabel!
    @IBOutlet var transportationAmt: UILabel!
    
    var loggedInUser: Results<User>?
    var userInterviews = [Interview]()
    var curInterview : Interview?
    
    // ------ Modal functionality -------
    @IBAction func showModal(sender: AnyObject) {
        print("Clicked on modal.")
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
            print("Company changed from \(curInterview?.company) to \(btnText).")
            companyLabelText.text = btnText
            setCompanyLogo(getCompanyImageLogo(companyLabelText.text!))
            
            for interview in userInterviews {
                if (interview.company == companyLabelText.text) {
                    self.curInterview = interview
                    self.loadBalance()
                }
            }
        }

        hideModal()
        hideBlur()
    }
    
    func getCompanyImageLogo(company: String) -> String {
        if company == "Airbnb" {
            return "airbnb_small"
        } else if company == "Apple" {
            return "apple_small"
        } else if company == "Google" {
            return "google_small"
        } else if company == "Intuit" {
            return "apple_small"    // Intuit logo eventually
        }
        
        return "google_small"                  // Microsoft logo eventually
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
    
    func customizeModalInitially() {
        print("Number of interviews lined up: ", self.userInterviews.count)
        
        for item in self.userInterviews {
            print(item.company)
        }
        
        modalView.layer.cornerRadius = 10.0
        modalView.layer.borderWidth = 0
        modalView.clipsToBounds = true
        
        if (userInterviews.count >= 1) {
            customizeCompanies(companyBtn1, index : 0)
        }
        
        if (userInterviews.count >= 2) {
            customizeCompanies(companyBtn2, index : 1)
        }
        
        if (userInterviews.count == 3) {
            customizeCompanies(companyBtn3, index : 2)
        }
    }
    
    func customizeCompanies(btn : UIButton, index : Int) {
        btn.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue:229/255, alpha: 1);
        btn.layer.cornerRadius = 6.0
        btn.layer.borderWidth = 0
        btn.clipsToBounds = true
        
        btn.setTitle(userInterviews[index].company, forState: .Normal)
    }
    
    // ------ App Functionality -------
    func loadBalance() {
        // Set amounts set forth by company
        let setFood = (self.curInterview?.company_budget?.food_amount)!
        let setLodging = (self.curInterview?.company_budget?.lodging_amount)!
        let setTransportation = (self.curInterview?.company_budget?.transportation_amount)!
        let setTotal = (self.curInterview?.company_budget?.total_amount)!
        
        // Home page company
        self.companyLabelText.text = self.curInterview?.company
        self.setCompanyLogo(getCompanyImageLogo((self.curInterview?.company)!))
        
        // HomePage FOOD Updated Balance
        let remainingFood = setFood - (self.curInterview?.food_consumed)!
        self.foodAmt.text = String(format:"$%.2f", remainingFood)
        
        // HomePage LODGING Updated Balance
        let remainingLodging = setLodging - (self.curInterview?.lodging_consumed)!
        self.lodgingAmt.text = String(format:"$%.2f", remainingLodging)
        
        // HomePage TRANSPORTATION Updated Balance
        let transportationRemaining = setTransportation - (self.curInterview?.transportation_consumed)!
        self.transportationAmt.text = String(format:"$%.2f", transportationRemaining)

        // HomePage TOTAL Updated Balance
        let totalRemaining = setTotal - (self.curInterview?.total_consumed)!
        let totalRemainingStr = String(format:"$%.2f", totalRemaining)
        let attributedString = NSMutableAttributedString(string: totalRemainingStr, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(80)])
        
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir Next", size: 48.0)!, range: NSRange(location: totalRemainingStr.indexOfCharacter(".")! + 1,length: 2))
        
        self.balanceLabelText.attributedText = attributedString

    }
    
    func setCompanyLogo(image_name: String) {
        let image: UIImage = UIImage(named: image_name)!
        companyImage.image = image;
    }
    
    func readInterviewObjectsfromFirebase(userId : String) {
        let interviewsRef = ref.childByAppendingPath("interviews")
        let budgetsRef = ref.childByAppendingPath("budgets")
        
        interviewsRef.queryOrderedByChild(userId).observeEventType(.ChildAdded, withBlock: { snapshot in
            
            let interview = Interview(uid : snapshot.key,
                interviewee_id : userId,
                position : (snapshot.value["position"] as? String)!,
                company : (snapshot.value["company"] as? String)!,
                start_date: (snapshot.value["start_date"] as? String)!,
                end_date : (snapshot.value["end_date"] as? String)!,
                total_consumed: 0,
                food_consumed:  0,
                lodging_consumed: 0,
                transportation_consumed: 0)
            
            budgetsRef.queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
                if interview.company == snapshot.key {
                    
                    let budget = Budget(company: snapshot.key,
                        total_amount: Double((snapshot.value["total_amt"] as? String)!)!,
                        food_amount : Double((snapshot.value["food_amt"] as? String)!)!,
                        lodging_amount : Double((snapshot.value["lodging_amt"] as? String)!)!,
                        transportation_amount: Double((snapshot.value["transportation_amt"] as? String)!)!)
                    
                    interview.company_budget = budget

                    // Appends the Interview object to 'userInterviews
                    self.userInterviews.append(interview)
                    
                    // Modal
                    self.customizeModalInitially();
                    self.hideBlur()
                    self.modalView.hidden = true;
                    
                    self.curInterview = self.userInterviews[0]
                    
//                    if (self.curInterview == nil) {
//                        self.curInterview = self.userInterviews[0]
//                    } else {
//                        // TODO: Read curInterview RealmSwift object
//                    }
                    
                    // Home Page & balance customization
                    self.loadBalance()
                }
            })
        })
    }
    
    func setUpCompanyButtons() {
        companyBtn1.setTitle("", forState: .Normal)
        companyBtn2.setTitle("", forState: .Normal)
        companyBtn3.setTitle("", forState: .Normal)
        
        company1Logo.image = nil
        company2Logo.image = nil
        company3Logo.image = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        //loadBalance();
    }
    
    // Initial view of Main storyboard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nHomeViewController...")
        
        navigationController!.setNavigationBarHidden(true, animated: false);

        // Customize buttons
        btnUpload.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1);
        btnHistory.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1);
        
        // Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 42/255, green: 183/255, blue:133/255, alpha: 1).CGColor, UIColor.init(red: 0/255, green: 94/255, blue:43/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, below: btnUpload.layer)
        
        // Retrieve 'loggedInUser' RealmSwift object info
        loggedInUser = realm.objects(User)
        print("loggedInUser: \t", loggedInUser!)
        let userId = loggedInUser![0].uid
        
        // Read'interview' objects such that interview.interviewee_id = userId & update array
        readInterviewObjectsfromFirebase(userId)
        
        // Modal
        setUpCompanyButtons()
        hideBlur()
        self.modalView.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
