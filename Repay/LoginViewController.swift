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

var ref = Firebase(url: "https://repay.firebaseio.com")

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var tempPasswordField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    var newUser: User?
    
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
        
        usersRef.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let dbEmail = snapshot.value["email"] as? String {
                
                if dbEmail == self.emailTextField.text {
                    print("User \(snapshot.key):")
                    print(snapshot.value)
                    
                    let dbTempPassword = snapshot.value["temp_password"] as? String
                    
                    if dbTempPassword == self.tempPasswordField.text {
                        self.newUser = User(uid: snapshot.key,
                            email: (snapshot.value["email"] as? String)!,
                            first_name: (snapshot.value["first_name"] as? String)!,
                            last_name: (snapshot.value["last_name"] as? String)!,
                            temp_password: (snapshot.value["temp_password"] as? String)!)
                        
                        print("User logged in successfully!")
                        
                        self.performSegueWithIdentifier("changePasswordSegue", sender: self)
                    } else {
                        print("User entered the incorrect password.")
                    }
                } else {
                    print("User does not exist in the database.")
                }
            }
        })
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