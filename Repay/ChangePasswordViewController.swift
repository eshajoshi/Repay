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

let ref = Firebase(url: "https://repay.firebaseio.com")
let realm = try! Realm()

class ChangePasswordViewController: UIViewController {
    @IBOutlet var modalView: UIView!
    @IBOutlet var welcomeNameLabel: UILabel!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    var userToValidate: User?
    
    @IBAction func handleChangePassword(sender: AnyObject) {
        print("\nUser changing password...")
        
        let usersRef = ref.childByAppendingPath("users")
        
        if (newPasswordTextField.hasText() && confirmPasswordTextField.hasText()) {
            if (newPasswordTextField.text! == confirmPasswordTextField.text!) {
                // Updating data to Firebase
                let tupleRef = usersRef.childByAppendingPath(userToValidate?.uid)
                let passwords = ["new_password": newPasswordTextField.text!,
                                 "confirm_password": confirmPasswordTextField.text!]
                
                tupleRef.updateChildValues(passwords)
                
                userToValidate?.new_password = newPasswordTextField.text!
                userToValidate?.confirm_password = confirmPasswordTextField.text!
                
                // Add new user object to Realm
                addNewUser((userToValidate?.uid)!,
                           email : (userToValidate?.email)!,
                           firstName: (userToValidate?.first_name)!,
                           lastName: (userToValidate?.last_name)!,
                           tempPassword: (userToValidate?.temp_password)!,
                           newPassword: newPasswordTextField.text!, confirmPassword: confirmPasswordTextField.text!)
                
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
    
    // Call registeredAppUsers Realm object and update this user object with new and confirm password
    // Write it back to Firebase
    
    var moduleLayer: CALayer {
        return modalView.layer
    }
    
    func addNewUser(uid : String, email : String, firstName : String, lastName: String,
                    tempPassword: String, newPassword : String, confirmPassword : String) {
        
        try! realm.write {
            let user = User()
            let registeredUsers = RegisteredAppUsers()
            
            user.uid =  uid
            user.email = email
            user.first_name = firstName
            user.last_name = lastName
            user.temp_password = tempPassword
            user.new_password = newPassword
            user.confirm_password = confirmPassword
            
            registeredUsers.users.append(user)
            registeredUsers.loggedInUser = user
            
            realm.add([user, registeredUsers])
        }
    }
    
    func customizeModule() {
        print("\nChangePasswordController...")
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
        
        confirmPasswordTextField.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        confirmPasswordTextField.borderStyle = UITextBorderStyle.None
        confirmPasswordTextField.layer.cornerRadius = 5.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            
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
