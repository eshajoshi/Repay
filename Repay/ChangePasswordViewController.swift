//
//  ChangePasswordViewController.swift
//  Repay
//
//  Created by Esha Joshi on 5/8/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

var realm = try! Realm()

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var modalView: UIView!
    @IBOutlet var welcomeNameLabel: UILabel!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var changePasswordBtn: UIButton!
    
    var userToValidate: User?
    
    @IBAction func handleChangePassword(sender: AnyObject) {
        print("\nUser changing password...")
        
        let usersRef = ref.childByAppendingPath("users")
        
        if (newPasswordTextField.hasText() && confirmPasswordTextField.hasText()) {
            if (newPasswordTextField.text! == confirmPasswordTextField.text!) {
                
                // Updating User data to Firebase
                let tupleRef = usersRef.childByAppendingPath(userToValidate?.uid)
                let passwords = ["new_password": newPasswordTextField.text!,
                                 "confirm_password": confirmPasswordTextField.text!]
                
                tupleRef.updateChildValues(passwords)
                
                userToValidate?.new_password = newPasswordTextField.text!
                userToValidate?.confirm_password = confirmPasswordTextField.text!
                
                // Add new user object to Realm
                try! realm.write {
                    let user = User(uid: (userToValidate?.uid)!,
                        email: (userToValidate?.email)!,
                        first_name: (userToValidate?.first_name)!,
                        last_name: (userToValidate?.last_name)!,
                        temp_password: (userToValidate?.temp_password)!,
                        new_password: newPasswordTextField.text!,
                        confirm_password: confirmPasswordTextField.text!)
                    
                    // let registeredUsers = RegisteredAppUsers()          // Is this always going to create new RegisteredAppUsers() instances?
                    //  registeredUsers.users.append(user)
                    //  registeredUsers.loggedInUser = user
                    
                    print("Adding User # \(user.uid) with name \(user.first_name) to RealmObject")
                    realm.add(user)
                }
                
                print("User changed password successfully.")
                performSegueWithIdentifier("homeViewSegue", sender: self)
            } else {
                print("Password fields do not match.")
                // TODO: Modal for password fields do not match
            }
        } else {
            print("User has not entered new password or confirm password.")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: Int = textField.tag + 1
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        
        if nextResponder == confirmPasswordTextField {
            print("confirmPasswordTextField is now first responder.")
            confirmPasswordTextField.becomeFirstResponder()         // Set next responder
        } else {
            print("Change password.")
            textField.resignFirstResponder()
            self.view.endEditing(true)                              // Remove keyboard
            //handleChangePassword(changePasswordBtn)
        }
        
        return false
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
        welcomeNameLabel.text = "Welcome " + (userToValidate?.first_name)! + ","
        
        newPasswordTextField.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        newPasswordTextField.borderStyle = UITextBorderStyle.None
        newPasswordTextField.layer.cornerRadius = 5.0
        newPasswordTextField.returnKeyType = UIReturnKeyType.Next
        newPasswordTextField.delegate = self
        newPasswordTextField.tag = 0
        
        confirmPasswordTextField.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        confirmPasswordTextField.borderStyle = UITextBorderStyle.None
        confirmPasswordTextField.layer.cornerRadius = 5.0
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.tag = 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "homeViewSegue") {
            let navVC = segue.destinationViewController as! UINavigationController
            let homeVC = navVC.viewControllers.first as! HomeViewController
            homeVC.userId = userToValidate?.uid
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nChangePasswordController...")
        
        // Gradient
        let layer = CAGradientLayer()
        layer.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [UIColor.init(red: 42/255, green: 183/255, blue:133/255, alpha: 1).CGColor, UIColor.init(red: 0/255, green: 94/255, blue:43/255, alpha: 1).CGColor]
        view.layer.insertSublayer(layer, atIndex: 0)
        
        // Module
        view.bringSubviewToFront(modalView)
        modalView.hidden = false;
        customizeModule()
        customizeModuleFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
