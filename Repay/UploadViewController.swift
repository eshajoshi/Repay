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
                let receiptId = Int(arc4random_uniform(900))
                
                // Populate Receipt object and append to curInterview.receipts (list)
                self.receiptObject = self.populateReceiptObject(receiptId)
                //self.updateReceiptsListInRealm(self.curInterview!, receiptObject: self.receiptObject!)
                
                // Update curInterview budgets
                self.updateInterviewBudgets(self.curInterview!)
                
                // Write Receipt tuple to Firebase
                self.writeReceiptTupleToFirebase(self.receiptObject!)
                
                // Write Image tuple to Firebase
                self.writeImageTupleToFirebase(self.receiptObject!.id, base64String: base64String)
                
                // Update curInterview object in Realm
                self.updateCurInterviewInRealm(self.curInterview!)
                print("Added/modified curInterview object to RealmSwift object.")
                
                self.performSegueWithIdentifier("confirmViewSegue", sender: self)
            }
        })
    }
    
    func populateReceiptObject(receiptId: Int) -> (Receipt) {
        print("Populating receipt object...")
        
        return Receipt(id: String(receiptId),
                       interview_id: self.curInterview!.uid,
                       company: self.curInterview!.company,
                       category: self.selectedCategory!,
                       first_name: self.first!,
                       last_name: self.last!,
                       position: self.curInterview!.position,
                       requested_amt: Double(self.amountInput.text!)!,
                       status: "todo",
                       timestamp: NSDate().timeIntervalSince1970 * 1000)
    }
    
//    func updateReceiptsListInRealm(interview: Interview, receiptObject: Receipt) {
//        print("Updating receipts list in Realm...")
//        
//        let updatedInterview = Interview(uid: interview.uid,
//                                         interviewee_id: interview.interviewee_id,
//                                         position: interview.position,
//                                         company: interview.company,
//                                         start_date: interview.start_date,
//                                         end_date: interview.end_date,
//                                         total_consumed: interview.total_consumed,
//                                         food_consumed: interview.food_consumed,
//                                         lodging_consumed: interview.lodging_consumed,
//                                         transportation_consumed: interview.transportation_consumed)
//        
//        for item in interview.receipts {
//            updatedInterview.receipts.append(item)
//        }
//        updatedInterview.receipts.append(receiptObject)
//        
//        do {
//            try realm.write() {
//                realm.add(updatedInterview, update: true)
//            }
//        } catch {
//            print("Error updating curInterview receipts list to Realm object!")
//        }
//    }
    
    func updateInterviewBudgets(interview: Interview) {
        print("Updating interview budgets...")
        
        // print(interview)
        
        setCompanyBudgets()
        
        let reqAmt = Double(self.amountInput.text!)!
        let category = self.selectedCategory!
        print("category: ", category)
        
        let newTotal = interview.total_consumed + reqAmt
        
        // Create updatedInterview object
        let updatedInterview = Interview()
        updatedInterview.uid = interview.uid
        updatedInterview.interviewee_id = interview.interviewee_id
        updatedInterview.position = interview.position
        updatedInterview.company = interview.company
        updatedInterview.start_date = interview.start_date
        updatedInterview.end_date = interview.end_date
        
        updatedInterview.food_consumed = interview.food_consumed
        updatedInterview.lodging_consumed = interview.lodging_consumed
        updatedInterview.transportation_consumed = interview.transportation_consumed
        updatedInterview.total_consumed = newTotal
        
        switch (category) {
            case "Food":
                print("interview.food_consumed", interview.food_consumed)
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
                    total_amount: snapshot.value["total_amt"] as! Double,
                    food_amount : snapshot.value["food_amt"] as! Double,
                    lodging_amount : snapshot.value["lodging_amt"] as! Double,
                    transportation_amount: snapshot.value["transportation_amt"] as! Double)
                
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
                            "company": receiptObject.company,
                            "category": receiptObject.category,
                            "first_name": receiptObject.first_name,
                            "last_name": receiptObject.last_name,
                            "position": receiptObject.position,
                            "requested_amt": receiptObject.requested_amt,
                            "status": receiptObject.status,
                            "timestamp": receiptObject.timestamp]
        
        let receiptKeyId = ref.childByAppendingPath("receipts").childByAutoId()
        receiptKeyId.setValue(receiptTuple);
        print("New receipt tuple of \(receiptObject.requested_amt) written to Firebase.")
    }
    
    func writeImageTupleToFirebase(receipt_id: String, base64String: String) {
        print("Writing image object to firebase...")
        
        let imageUid = Int(arc4random_uniform(900))
        let imageTuple = ["uid": imageUid,
                          "receipt_id": receipt_id,
                          "imageStr": base64String]
        
        let imageKeyId = ref.childByAppendingPath("images").childByAutoId()
        imageKeyId.setValue(imageTuple);
        print("New image tuple of id: \(imageUid) and receipt_id: \(receipt_id) written to Firebase.")
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
        
        print("\nUploadViewController...")
        
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
