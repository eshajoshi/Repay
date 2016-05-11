//
//  LoginViewController.swift
//  Repay
//
//  Created by Esha Joshi on 5/2/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

let repayRef = "https://repay.firebaseio.com/"

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var tempPasswordField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    var ref = Firebase(url: repayRef)
    var newUser = User()
    
    /* Validate user email and temporary password with database */
    @IBAction func handleLogin(sender: AnyObject) {
        if (emailTextField.hasText() && tempPasswordField.hasText()) {
            print("Trying to validate user with email: \(emailTextField.text!)\n")
            
            // Value of 'loginStatus' changes
            findUserFromFirebase()
        } else {
            print("User has not entered in email or temp. password...")
        }
    }
    
    @IBAction func handleUnknownPassword(sender: AnyObject) {
        print("User does not know password...")
    }
    
    func findUserFromFirebase() {
        print("Retrieving user info from Firebase...\t")
        let usersRef = ref.childByAppendingPath("users")
        
        newUser = User()
        
        usersRef.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let dbEmail = snapshot.value["email"] as? String {
                
                if dbEmail == self.emailTextField.text {
                    print("User \(snapshot.key):")
                    print("\tEmail: \(dbEmail)")
                    
                    let dbTempPassword = snapshot.value["temp_password"] as? String
                    
                    if dbTempPassword == self.tempPasswordField.text {
                        print("\tTemp Password: \(dbTempPassword!)")
                        
                        let first_name = snapshot.value["first_name"] as? String
                        let last_name = snapshot.value["last_name"] as? String
                        
                        print("\tFirst Name: \(first_name!)")
                        print("\tLast Name: \(last_name!)")

                        /* Adding user information to Realm data */
                        self.setUpNewUserToSend(snapshot.key,
                            email: self.emailTextField.text!,
                            tempPassword: self.tempPasswordField.text!,
                            firstName: first_name!,
                            lastName: last_name!)
                        
                        print("User logged in successfully!")
                        
                        // Send newUser object in segue to ChangePasswordViewController
                        self.performSegueWithIdentifier("changePasswordSegue", sender: self)

                        return
                    } else {
                        //self.loginStatus = false
                        print("User entered the incorrect password.")
                    }
                } else {
                    print("User does not exist in the database.")
                }
            }
        })
    }
    
    func setUpNewUserToSend(uid : String, email : String, tempPassword : String,
                            firstName : String, lastName: String) {
        newUser.uid =  uid
        newUser.email = email
        newUser.temp_password = tempPassword
        newUser.first_name = firstName
        newUser.last_name = lastName
    }
    
    /* Enable/disable "log in" button based on non-nil user input */
    func enableLoginButton() {
        if (emailTextField.hasText() && tempPasswordField.hasText()) {
            loginBtn.backgroundColor = UIColor(red: 90/255, green: 178/255, blue: 143/255, alpha: 1.0)
        } else {
            loginBtn.backgroundColor = UIColor(red: 166/255, green: 168/255, blue: 168/255, alpha: 0.5)
        }
    }
        
    /* Sends newUser object to ChangePasswordViewController */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "changePasswordSegue") {
            let changePasswordVC = segue.destinationViewController as! ChangePasswordViewController
            changePasswordVC.userToValidate = self.newUser
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableLoginButton()
        
        // Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 42/255, green: 183/255, blue:133/255, alpha: 1).CGColor, UIColor.init(red: 0/255, green: 94/255, blue:43/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}