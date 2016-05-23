//
//  UploadViewController.swift
//  Repay
//
//  Created by Esha Joshi on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

extension UIImage {
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    func resizeToWidth(width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

class UploadViewController:
    UITableViewController, UINavigationControllerDelegate,
        UIImagePickerControllerDelegate {
    
    @IBOutlet var amountInput: UITextField!
    @IBOutlet var barBtnBack: UIBarButtonItem!
    @IBOutlet var btnRequest: UIButton!
    @IBOutlet var imagePreview: UIImageView!
    
    var curInterview: Interview?
    var receiptObject: Receipt?
    var selectedCategory: String?
    var imagePicker: UIImagePickerController!
    var first: String?
    var last: String?
    var company_budget_food: Double?
    var company_budget_lodging: Double?
    var company_budget_trans: Double?
    
    @IBAction func inputReimbursementAmt(sender: UITextField) {
        amountInput.text = (sender.text)!
    }
    
    @IBAction func handleBtnBack(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func onCamera(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onRequest(sender: AnyObject) {
        ref.childByAppendingPath("users").observeEventType(.ChildAdded, withBlock: { snapshot in
            if self.curInterview!.interviewee_id == snapshot.key as String {
                self.first = snapshot.value["first_name"] as? String
                self.last = snapshot.value["last_name"] as? String
                
                // Image converted to base64 string for storage on Firebase
                let imageData = UIImagePNGRepresentation(self.imagePreview.image!.resize(0.5))
                let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                
                // TODO: Figure out how to populate the unique receipt id (random numbers)
                let receiptId = Int(arc4random_uniform(6) + 100)
                
                // Populate Receipt object and append to curInterview.receipts (list)
                self.receiptObject = self.populateReceiptObject(receiptId, base64String: base64String)
                self.updateReceiptsListInRealm(self.curInterview!, receiptObject: self.receiptObject!)
                
                // Update curInterview budgets
                self.updateInterviewBudgets(self.curInterview!)
                
                // Write Receipt tuple to Firebase
                self.writeReceiptTupleToFirebase(self.receiptObject!)
                
                // Update curInterview object in Realm
                self.updateCurInterviewInRealm(self.curInterview!)
                print("Added/modified curInterview object to RealmSwift object.")
                
                self.performSegueWithIdentifier("confirmViewSegue", sender: self)
            }
        })
    }
    
    func populateReceiptObject(receiptId: Int, base64String: String) -> (Receipt) {
        print("Populating receipt object...")
        
        return Receipt(id: String(receiptId),
                       interview_id: self.curInterview!.uid,
                       category: self.selectedCategory!,
                       first_name: self.first!,
                       last_name: self.last!,
                       position: self.curInterview!.position,
                       image: base64String,
                       requested_amt: Double(self.amountInput.text!)!,
                       status: "todo",
                       timestamp: NSDate().timeIntervalSince1970 * 1000)
    }
    
    func updateReceiptsListInRealm(interview: Interview, receiptObject: Receipt) {
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
        
        updatedInterview.receipts.append(receiptObject)
        
        do {
            try realm.write() {
                realm.add(updatedInterview, update: true)
            }
        } catch {
            print("Error updating curInterview receipts list to Realm object!")
        }
    }
    
    func updateInterviewBudgets(interview: Interview) {
        print("Updating interview budgets...")
        
        // print(interview)
        
        setCompanyBudgets()
        
        let reqAmt = Double(self.amountInput.text!)!
        let category = self.selectedCategory!
        
        let newTotal = interview.total_consumed + Double(self.amountInput.text!)!
        
        // Create updatedInterview object
        let updatedInterview = Interview()
        updatedInterview.uid = interview.uid
        updatedInterview.interviewee_id = interview.interviewee_id
        updatedInterview.position = interview.position
        updatedInterview.company = interview.company
        updatedInterview.start_date = interview.start_date
        updatedInterview.end_date = interview.end_date
        
        switch (category) {
            case "Food":
                let newFoodTotal = interview.food_consumed + reqAmt;
                
                if (newFoodTotal > company_budget_food) {
                    // TODO: Modal for spending too much of company FOOD budget
                }
                
                updatedInterview.food_consumed = newFoodTotal

                break;
            case "Lodging":
                let newLodgingTotal = interview.lodging_consumed + reqAmt;
                
                if (newLodgingTotal > company_budget_lodging) {
                    // TODO: Modal for spending too much of company LODGING budget
                }
                
                updatedInterview.lodging_consumed = newLodgingTotal

                break;
            case "Transportation":
                let newTransTotal = interview.transportation_consumed + reqAmt;
                
                if (newTransTotal > company_budget_trans) {
                    // TODO: Modal for spending too much of company TRANS budget
                }
                
                updatedInterview.transportation_consumed = newTransTotal
                
                break;
            default:
                break;
        }
        
        updatedInterview.total_consumed = newTotal
        
        do {
            try realm.write() {
                realm.add(updatedInterview, update: true)
            }
        } catch {
            print("Error adding/updating curInterview budgets to Realm object!")
        }
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
                
                self.company_budget_food = budget.food_amount
                self.company_budget_lodging = budget.lodging_amount
                self.company_budget_trans = budget.transportation_amount
                
                // Update curInterview object in Realm with new budgets
                self.updateCurInterviewInRealm(self.curInterview!, budget: budget)
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
    
    func writeReceiptTupleToFirebase(receiptObject: Receipt) {
        print("Writing receipt tuple to firebase...")
        
        let receiptTuple = ["id": receiptObject.id,
                            "interview_id": receiptObject.interview_id,
                            "category": receiptObject.category,
                            "first_name": receiptObject.first_name,
                            "last_name": receiptObject.last_name,
                            "position": receiptObject.position,
                            "image": receiptObject.image,
                            "requested_amt": receiptObject.requested_amt,
                            "status": receiptObject.status,
                            "timestamp": receiptObject.timestamp]
        
        let receiptKeyId = ref.childByAppendingPath("receipts").childByAutoId();
        receiptKeyId.setValue(receiptTuple);
        print("New receipt tuple of \(receiptObject.requested_amt) written to Firebase.")
    }
    
    func updateCurInterviewInRealm(interview: Interview) {
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
        
        do {
            try realm.write() {
                realm.add(updatedInterview, update: true)
            }
        } catch {
            print("Error adding/updating curInterview to Realm object!")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePreview.contentMode = UIViewContentMode.ScaleAspectFit;
        imagePreview.image = image;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "confirmViewSegue") {
            let confirmVC = segue.destinationViewController as! ConfirmViewController
            confirmVC.lastReceipt = self.receiptObject
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nUploadViewController")
        
        // Request Button
        btnRequest.backgroundColor = UIColor.groupTableViewBackgroundColor();
        
        // 'Select Category' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Back' Bar Button Item
        barBtnBack.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnBack.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        print("Current interview: ", (curInterview?.uid)!)
        print("Selected category: ", (selectedCategory)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
