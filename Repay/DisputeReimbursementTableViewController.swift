//
//  DisputeReimbursementTableViewController.swift
//  Repay
//
//  Created by Esha Joshi on 6/2/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

class DisputeReimbursementTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var barBtnBack: UIBarButtonItem!
    @IBOutlet var receiptImage: UIImageView!
    @IBOutlet var date_requested: UILabel!
    @IBOutlet var approved_amt: UILabel!
    @IBOutlet var approved_amt_view: UIView!
    @IBOutlet var new_requested_amt: UITextField!
    @IBOutlet var new_requested_amt_view: UIView!
    @IBOutlet var new_reason: UITextField!
    @IBOutlet var new_reason_view: UIView!
    @IBOutlet var requestBtn: UIButton!
    
    var receiptCell: HistoryTableViewCell?
    var image: UIImage?
    var approved_amt_str: String?
    
    @IBAction func handleBtnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func enterNewAmount(sender: AnyObject) {
        print("User is trying to request a new amount...")
    }
    
    @IBAction func requestNewReason(sender: AnyObject) {
        print("User is providing a reason for new request...")
    }
    
    @IBAction func handleRequest(sender: AnyObject) {
        print("User is requesting a new reimbursement...")
        
        //let receiptsRef = ref.childByAppendingPath("receipts")
        
//        if (newPasswordTextField.hasText() && confirmPasswordTextField.hasText()) {
//            if (newPasswordTextField.text! == confirmPasswordTextField.text!) {
//                
//                // Updating User data to Firebase
//                let tupleRef = usersRef.childByAppendingPath(userToValidate?.uid)
//                let passwords = ["new_password": newPasswordTextField.text!,
//                                 "confirm_password": confirmPasswordTextField.text!]
//                
//                tupleRef.updateChildValues(passwords)
//                
//                userToValidate?.new_password = newPasswordTextField.text!
//                userToValidate?.confirm_password = confirmPasswordTextField.text!
//                
//                // Add new user object to Realm
//                try! realm.write {
//                    let user = User(uid: (userToValidate?.uid)!,
//                        email: (userToValidate?.email)!,
//                        first_name: (userToValidate?.first_name)!,
//                        last_name: (userToValidate?.last_name)!,
//                        temp_password: (userToValidate?.temp_password)!,
//                        new_password: newPasswordTextField.text!,
//                        confirm_password: confirmPasswordTextField.text!)
//                    
//                    // let registeredUsers = RegisteredAppUsers()          // Is this always going to create new RegisteredAppUsers() instances?
//                    //  registeredUsers.users.append(user)
//                    //  registeredUsers.loggedInUser = user
//                    
//                    print("Adding User # \(user.uid) with name \(user.first_name) to RealmObject")
//                    realm.add(user)
//                }
//                
//                print("User changed password successfully.")
//                performSegueWithIdentifier("homeViewSegue", sender: self)
//            } else {
//                print("Password fields do not match.")
//                // TODO: Modal for password fields do not match
//            }
//        } else {
//            print("User has not entered new password or confirm password.")
//        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: Int = textField.tag + 1
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        
        if nextResponder == new_reason {
            print("new_reason is now first responder.")
            new_reason.becomeFirstResponder()               // Set next responder
        } else if nextTag == 2 {
            print("Request.")
            new_reason.resignFirstResponder()               // Remove keyboard
            handleRequest(requestBtn)                       // "Request"
        }
        
        return false
    }

    func loadTVCFields() {
        print("Loading ReimbursementTVC fields...")
        
        receiptImage.image = image
        date_requested.text = receiptCell?.date.text
        approved_amt.text = approved_amt_str
    }
    
    override func viewDidAppear(animated: Bool) {
        loadTVCFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nDisputeReimbursementTableViewController...")
        
        // 'History' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Back' Bar Button Item
        barBtnBack.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnBack.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // Views
        new_requested_amt_view.layer.cornerRadius = 5.0
        approved_amt_view.layer.cornerRadius = 5.0
        new_reason_view.layer.cornerRadius = 5.0
        
        // Labels
        let clearColor: UIColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        new_requested_amt.layer.borderColor = clearColor.CGColor
        new_requested_amt.layer.borderWidth = 0;
        new_requested_amt.layer.cornerRadius = 5.0;
        new_reason.layer.borderColor = clearColor.CGColor
        new_reason.layer.borderWidth = 0;
        new_reason.layer.cornerRadius = 5.0;
        
        date_requested.sizeToFit()
        date_requested.adjustsFontSizeToFitWidth = true
        approved_amt.sizeToFit()
        approved_amt.adjustsFontSizeToFitWidth = true
        new_requested_amt.sizeToFit()
        new_requested_amt.adjustsFontSizeToFitWidth = true
        new_reason.sizeToFit()
        new_reason.adjustsFontSizeToFitWidth = true
        
        // Load image, date and approved amount
        loadTVCFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}
