//
//  LoginViewController.swift
//  Repay
//
//  Created by Esha Joshi on 5/2/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

let repayUsersFirebase = "https://repay.firebaseio.com/users"

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var tempPasswordField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    let ref = Firebase(url: repayUsersFirebase)
    
    @IBAction func enableLoginButton(sender: AnyObject) {
        let loginBtn = sender as! UIButton
        
        if (emailTextField.hasText() && tempPasswordField.hasText()) {
            loginBtn.backgroundColor = UIColor(red: 90/255, green: 178/255, blue: 143/255, alpha: 1.0)
        } else {
            loginBtn.backgroundColor = UIColor(red: 90/255, green: 178/255, blue: 143/255, alpha: 0.5)
        }
    }
    
    /* Validate user email and temporary password with database */
    @IBAction func handleLogin(sender: AnyObject) {
        print("User logging in...")
        
        ref.createUser(emailTextField.text, password: tempPasswordField.text, withValueCompletionBlock: { error, result in
            
            if error != nil {
                print("Error with validating user: \(self.emailTextField.text)...")
                print(error)
            } else {
                let uid = result["uid"] as? String
                print("Successfully created user with uid: \(uid)")
                
                //self.ref.childByAppendingPath("users/\(uid)").setValue(users)
            }
        })
    }
    
    @IBAction func handleUnknownPassword(sender: AnyObject) {
        print("User does not know/forgotten password...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableLoginButton(loginBtn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}