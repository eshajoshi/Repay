//
//  UploadViewController.swift
//  Repay
//
//  Created by Esha Joshi on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

let repayReceiptsFirebase = "https://repay.firebaseio.com/receipts"

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
    
    var ref = Firebase(url: repayReceiptsFirebase)
    
    @IBOutlet var amountInput: UITextField!
    @IBOutlet var barBtnBack: UIBarButtonItem!
    @IBOutlet var btnRequest: UIButton!
    @IBOutlet var imagePreview: UIImageView!
    var imagePicker: UIImagePickerController!
    
    @IBAction func inputReimbursementAmt(sender: UITextField) {
        let reimbursementAmt = sender.text
        
//        if amountInput.text?.rangeOfString("$") == nil {
//            amountInput.text = "$" + reimbursementAmt!
//        }
        
        amountInput.text = reimbursementAmt!
    }
    
    @IBAction func onCamera(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onRequest(sender: AnyObject) {
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(amountInput.text, forKey: "amount")
        let category = prefs.stringForKey("requestedCategory")!
        
        // Image converted to base64 string for storage on Firebase
        let imageData = UIImagePNGRepresentation(imagePreview.image!.resize(0.5))
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        // TODO: Need to read the user information from Firebase and write it back
        // to Firebase with the individual receipt information
        let receipts = ["first_name": "Esha",
                        "id": 765,
                        "image": base64String,
                        "last_name": "Joshi",
                        "position": "Software Engineer",
                        "category": category,
                        "requested_amt": String(amountInput.text!),
                        "status": "todo",
                        "timestamp": NSDate().timeIntervalSince1970 * 1000
                    ]
        
        let post1Ref = ref.childByAutoId()
        post1Ref.setValue(receipts)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePreview.contentMode = UIViewContentMode.ScaleAspectFit;
        imagePreview.image = image;
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        btnRequest.backgroundColor = UIColor.groupTableViewBackgroundColor();
        
        // 'Select Category' Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 0/255, green: 94/255, blue: 43/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // 'Cancel' Bar Button Item
        barBtnBack.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)!], forState: UIControlState.Normal)
        barBtnBack.tintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

}
