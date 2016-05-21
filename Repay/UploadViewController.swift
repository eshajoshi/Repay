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
    UITableViewController,UINavigationControllerDelegate,
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
    
    @IBAction func inputReimbursementAmt(sender: UITextField) {
        let reimbursementAmt = sender.text
        
//        if amountInput.text?.rangeOfString("$") == nil {
//            amountInput.text = "$" + reimbursementAmt!
//        }
        
        amountInput.text = reimbursementAmt!
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
                self.curInterview!.receipts.append(self.receiptObject!)
                
                // Update curInterview budgets
                self.updateInterviewBudgets()
                
                // Write Receipt tuple to Firebase
                self.writeReceiptTupleToFirebase(self.receiptObject!)
                
                // Write curInterview (with added Receipt object) to Realm Swift object
                try! realm.write {
                    realm.add(self.curInterview!)
                }
                print("Added curInterview object to RealmSwift object.")
                
                self.performSegueWithIdentifier("confirmViewSegue", sender: self)
            }
        })
    }
    
    func populateReceiptObject(receiptId: Int, base64String: String) -> (Receipt) {
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
    
    func updateInterviewBudgets() {
        let reqAmt = Double(self.amountInput.text!)!
        let category = self.selectedCategory!
        
        let newTotal = curInterview!.total_consumed + Double(self.amountInput.text!)!
        
        switch (category) {
            case "Food":
                let newFoodTotal = curInterview!.food_consumed + reqAmt;
                
                if (newFoodTotal > curInterview!.company_budget!.food_amount) {
                    // TODO: Modal for spending too much of company FOOD budget
                }
                
                self.curInterview!.food_consumed = newFoodTotal
            case "Lodging":
                let newLodgingTotal = curInterview!.lodging_consumed + reqAmt;
                
                if (newLodgingTotal > curInterview!.company_budget!.lodging_amount) {
                    // TODO: Modal for spending too much of company LODGING budget
                }
                
                self.curInterview!.lodging_consumed = newLodgingTotal
            case "Transportation":
                let newTransTotal = curInterview!.transportation_consumed + reqAmt;
                
                if (newTransTotal > curInterview!.company_budget!.transportation_amount) {
                    // TODO: Modal for spending too much of company TRANS budget
                }
                
                self.curInterview!.transportation_consumed = newTransTotal
            default:
                self.curInterview!.total_consumed = newTotal
                break;
        }
    }
    
    func writeReceiptTupleToFirebase(receiptObject: Receipt) {
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
        
        // 'Cancel' Bar Button Item
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
