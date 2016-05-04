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
    
    let ref = Firebase(url: repayRef)
    
    /* Validate user email and temporary password with database */
    @IBAction func handleLogin(sender: AnyObject) {
        if (emailTextField.hasText() && tempPasswordField.hasText()) {
            print("Trying to validate user with email: \(emailTextField.text!)\n")
            
            getUsersFromFirebase()

        } else {
            print("User has not entered in email or temp. password...")
        }
    }
    
    @IBAction func handleUnknownPassword(sender: AnyObject) {
        print("User does not know password...")
    }
    
    func getUsersFromFirebase() {
        print("Retrieving user from Firebase...\t")
        let usersRef = ref.childByAppendingPath("users")
        
        usersRef.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let dbEmail = snapshot.value["email"] as? String {
                if dbEmail == self.emailTextField.text {
                    print("User \(snapshot.key)\t")
                    print("\(snapshot.key) Email: \(dbEmail)")
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