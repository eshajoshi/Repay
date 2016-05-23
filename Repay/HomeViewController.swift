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
    
    var loggedInUsers: Results<User>?
    var loggedInUser: User?
    var userInterviews = [Interview]()
    var curInterview: Interview?
    var userId: String?
    
    // ------ Modal functionality -------
    @IBAction func showModal(sender: AnyObject) {
        print("\nClicked on modal:")
        self.modalView.hidden = false
        UIView.animateWithDuration(0.4,
                                   delay: 0.0,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    self.modalView.alpha = 1
            },
                                   completion: { finished in
        })
        
        showBlur()
    }
    
    @IBAction func handleCompanyButtonClicked(sender: AnyObject) {
        let button = sender as! UIButton
        let btnText = button.currentTitle! as String
        
        if btnText != "Cancel" {
            print("\tCompany changed from \((curInterview?.company)!) to \(btnText).")
            companyLabelText.text = btnText
            setCompanyLogo(companyLabelText.text!, view: companyImage)
            
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
    
    func getCompanyImageName(company: String, view: UIImageView) -> String {
        if company == "Airbnb" {
            if (view == companyImage) {
                return "airbnb_large"
            }
            
            return "airbnb_small"
        } else if company == "Apple" {
            if (view == companyImage) {
                return "apple_large"
            }
                
            return "apple_small"
        } else if company == "Google" {
            if (view == companyImage) {
                return "google_large"
            }
            
            return "google_small"
        } else if company == "Intuit" {
            if (view == companyImage) {
                return "intuit_large"
            }
            
            return "intuit_small"
        } else if company == "Microsoft" {
            if (view == companyImage) {
                return "microsoft_large"
            }
            
            return "microsoft_small"
        }
        
        if (view == companyImage) {
            return "workday_large"
        }
            
        return "workday_small"

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
        print("\nNumber of interviews lined up: ", self.userInterviews.count)
        
        for item in self.userInterviews {
            print(item.company)
        }
        
        modalView.layer.cornerRadius = 10.0
        modalView.layer.borderWidth = 0
        modalView.clipsToBounds = true
        
        if (userInterviews.count >= 1) {
            customizeCompanies(companyBtn1, index : 0)
            setCompanyLogo(userInterviews[0].company, view: company1Logo)
        }
        
        if (userInterviews.count >= 2) {
            customizeCompanies(companyBtn2, index : 1)
            setCompanyLogo(userInterviews[1].company, view: company2Logo)
        }
        
        if (userInterviews.count == 3) {
            customizeCompanies(companyBtn3, index : 2)
            setCompanyLogo(userInterviews[2].company, view: company3Logo)
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
    @IBAction func handleUploadReceipt(sender: AnyObject) {
        self.performSegueWithIdentifier("selectCategorySegue", sender: self)
    }
    
    func setCompanyLogo(companyName: String, view: UIImageView) {
        let image: UIImage = UIImage(named: getCompanyImageName(companyName, view: view))!
        view.image = image;
    }
    
    func readInterviewObjectsfromFirebase(userId : String) {
        let interviewsRef = ref.childByAppendingPath("interviews")
        let budgetsRef = ref.childByAppendingPath("budgets")
        
        interviewsRef.queryOrderedByChild("interviewee_id").observeEventType(.ChildAdded, withBlock: { snapshot in
            
            if userId == snapshot.value["interviewee_id"] as? String {
                
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
                    }
                })
            }
        })
    }

    func loadBalance() {
        print("Loading new balances...")
        //print(curInterview!)
        
        // Set amounts set forth by company
        let setFood = (curInterview?.company_budget?.food_amount)!
        let setLodging = (curInterview?.company_budget?.lodging_amount)!
        let setTransportation = (curInterview?.company_budget?.transportation_amount)!
        let setTotal = (curInterview?.company_budget?.total_amount)!
        
        // Home page company
        self.companyLabelText.text = curInterview?.company
        self.setCompanyLogo((curInterview?.company)!, view: companyImage)
        
        // HomePage FOOD Updated Balance
        let remainingFood = setFood - (curInterview?.food_consumed)!
        self.foodAmt.text = String(format:"$%.2f", remainingFood)
        
        // HomePage LODGING Updated Balance
        let remainingLodging = setLodging - (curInterview?.lodging_consumed)!
        self.lodgingAmt.text = String(format:"$%.2f", remainingLodging)
        
        // HomePage TRANSPORTATION Updated Balance
        let transportationRemaining = setTransportation - (curInterview?.transportation_consumed)!
        self.transportationAmt.text = String(format:"$%.2f", transportationRemaining)

        // HomePage TOTAL Updated Balance
        let totalRemaining = setTotal - (curInterview?.total_consumed)!
        let totalRemainingStr = String(format:"$%.2f", totalRemaining)
        let attributedString = NSMutableAttributedString(string: totalRemainingStr, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(80)])
        
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir Next", size: 48.0)!, range: NSRange(location: totalRemainingStr.indexOfCharacter(".")! + 1,length: 2))
        
        balanceLabelText.attributedText = attributedString

    }

    func setCompanyBudgets() {
        print("Setting company budgets...")
        
        let budgetsRef = ref.childByAppendingPath("budgets")
        
        budgetsRef.queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            if self.curInterview!.company == snapshot.key {
                
                let budget = Budget(company: snapshot.key,
                    total_amount: Double((snapshot.value["total_amt"] as? String)!)!,
                    food_amount : Double((snapshot.value["food_amt"] as? String)!)!,
                    lodging_amount : Double((snapshot.value["lodging_amt"] as? String)!)!,
                    transportation_amount: Double((snapshot.value["transportation_amt"] as? String)!)!)
                
                // Update curInterview object in Realm with new budgets
                self.updateCurInterviewInRealm(self.curInterview!, budget: budget)
                
                self.loadBalance()
            }
        })
    }
    
    func updateCurInterviewInRealm(interview: Interview, budget: Budget) {
        let updatedInterview = Interview(uid: interview.uid,
                                         interviewee_id: interview.interviewee_id,
                                         position: interview.position,
                                         company: interview.company,
                                         start_date: interview.start_date,
                                         end_date: interview.end_date,
                                         total_consumed: interview.total_consumed,
                                         food_consumed: interview.food_consumed,
                                         lodging_consumed: interview.lodging_consumed,
                                         transportation_consumed: interview.transportation_consumed)
        
        updatedInterview.company_budget = budget
        
        do {
            try realm.write() {
                realm.add(updatedInterview, update: true)
            }
        } catch {
            print("Error adding/updating curInterview to Realm object!")
        }
    }
    
    func setUpCompanyButtons() {
        companyBtn1.setTitle("", forState: .Normal)
        companyBtn2.setTitle("", forState: .Normal)
        companyBtn3.setTitle("", forState: .Normal)
        
        company1Logo.image = nil
        company2Logo.image = nil
        company3Logo.image = nil
    }
    
    /* Read curInterview object from RealmSwift */
    func updateCurInterview() {
        let realmInterviews = realm.objects(Interview)
        
        if (realmInterviews.count > 0) {
            print(realmInterviews)

            self.curInterview = realmInterviews[0]
            
            print("Updated Realm curInterview:")
            print("\t food: \(self.curInterview!.food_consumed)")
            print("\t lodging: \(self.curInterview!.lodging_consumed)")
            print("\t trans: \(self.curInterview!.transportation_consumed)")
            print("\t receipts: \(self.curInterview!.receipts)")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        print("HomeViewController - viewDidAppear")
        updateCurInterview()
        
        if (curInterview!.company_budget == nil) {
            setCompanyBudgets()
        } else {
            loadBalance()
        }
    }
    
    /* Sends curInterview object to CategoryTableViewController */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "selectCategorySegue") {
            let navVC = segue.destinationViewController as! UINavigationController
            let selectCategoryVC = navVC.viewControllers.first as! CategoryTableViewController
            
            selectCategoryVC.curInterview = self.curInterview
        } else if (segue.identifier == "selectHistorySegue") {
            let navVC = segue.destinationViewController as! UINavigationController
            let selectHistoryVC = navVC.viewControllers.first as! HistoryTableViewController
            
            selectHistoryVC.curInterview = self.curInterview
        }
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
        let predicate = NSPredicate(format: "uid = %@", userId!)
        loggedInUsers = realm.objects(User).filter(predicate)
        loggedInUser = loggedInUsers![0]
        print("loggedInUser: \t", loggedInUser)
        print("userId logged in: ", userId!)
        
        // Read'interview' objects such that interview.interviewee_id = userId & update array
        readInterviewObjectsfromFirebase(userId!)
        
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
