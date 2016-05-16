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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var modalView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var tempPasswordField: UITextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var logInBtn: UIButton!
    
    var newUser: User?
    
    /* Validate user email and temporary password with database */
    @IBAction func handleSignUp(sender: AnyObject) {
        print("User is trying to sign up...")
        
        if (emailTextField.hasText() && tempPasswordField.hasText()) {
            print("Trying to validate user with email: \(emailTextField.text!)\n")
            
            // Value of 'loginStatus' changes
            findUserFromFirebase()
        } else {
            print("User has not entered in email or temp. password...")
        }
    }
    
    @IBAction func handleLogIn(sender: AnyObject) {
        print("User is trying to log in...")

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: Int = textField.tag + 1
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        
        if nextResponder == tempPasswordField {
            print("tempPasswordField is now first responder.")
            tempPasswordField.becomeFirstResponder()        // Set next responder
        } else {
            print("Sign up.")
            textField.resignFirstResponder()                // Remove keyboard
            handleSignUp(signUpBtn)
        }
        
        return false
    }
    
    func findUserFromFirebase() {
        print("Retrieving user info from Firebase...\t")
        
        let usersRef = ref.childByAppendingPath("users")
        
        usersRef.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let dbEmail = snapshot.value["email"] as? String {

                if dbEmail == self.emailTextField.text! {
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
                        return
                    } else {
                        print("User entered the incorrect password.")
                    }
                } else {
                    print("User does not exist in the database.")
                }
            }
        })
    }
    
    var moduleLayer: CALayer {
        return modalView.layer
    }
    
    func customizeModule() {
        print("Customize module")
        modalView.layer.zPosition = 1;
        modalView.layer.cornerRadius = 10.0
        modalView.layer.borderWidth = 0
        modalView.clipsToBounds = true
        
        moduleLayer.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1).CGColor
        moduleLayer.borderWidth = 0
    }
    
    func customizeModuleFields() {
        emailTextField.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        emailTextField.borderStyle = UITextBorderStyle.None
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.delegate = self
        emailTextField.tag = 0
        
        tempPasswordField.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        tempPasswordField.borderStyle = UITextBorderStyle.None
        tempPasswordField.layer.cornerRadius = 5.0
        tempPasswordField.returnKeyType = UIReturnKeyType.Go
        tempPasswordField.delegate = self
        tempPasswordField.tag = 1
        
        signUpBtn.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        signUpBtn.tag = 2
        
        logInBtn.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        logInBtn.layer.cornerRadius = 5.0
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
        
        // Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 42/255, green: 183/255, blue:133/255, alpha: 1).CGColor, UIColor.init(red: 0/255, green: 94/255, blue:43/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, atIndex: 0)
        
        // Module
        customizeModule()
        customizeModuleFields()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
