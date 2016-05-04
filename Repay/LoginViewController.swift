//
//  LoginViewController.swift
//  Repay
//
//  Created by Esha Joshi on 5/2/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

let repayRef = "https://repay.firebaseio.com/"

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var tempPasswordField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    var ref = Firebase(url: repayRef)
    var users = RegisteredAppUsers()
    
    /* Validate user email and temporary password with database */
    @IBAction func handleLogin(sender: AnyObject) {
        if (emailTextField.hasText() && tempPasswordField.hasText()) {
            print("Trying to validate user with email: \(emailTextField.text!)\n")
            
            // Value of 'userStatus' changes
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
                    print("\tEmail: \(dbEmail)")
                    
                    let dbTempPassword = snapshot.value["temp_password"] as? String
                    
                    if dbTempPassword == self.tempPasswordField.text {
                        print("\tTemp Password: \(dbTempPassword!)")
                        
                        let first_name = snapshot.value["first_name"] as? String
                        let last_name = snapshot.value["last_name"] as? String
                        
                        print("\tFirst Name: \(first_name!)")
                        print("\tLast Name: \(last_name!)")
                        
                        // Create new Realm user
                        let newUser = User()
                        newUser.email = self.emailTextField.text!
                        newUser.first_name = first_name!
                        newUser.last_name = last_name!
                        newUser.temp_password = self.tempPasswordField.text!

                        // Append Realm user to the users list and update last added
                        self.users.users.append(newUser)
                        self.users.lastAdded = newUser
                        
                        print("User logged in successfully!")
                        return
                    } else {
                        print("User entered the incorrect password.")
                        
                        // TODO: Modal for incorrect username/password
                    }
                } else {
                    print("User does not exist in the database.")
                    
                    // TODO: Modal for incorrect username/password
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableLoginButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}