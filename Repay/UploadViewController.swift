//
//  UploadViewController.swift
//  Repay
//
//  Created by Kevin Vincent on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit
import Firebase

let repayFirebaseUrl = "https://repay.firebaseio.com/receipts"

class UploadViewController:
    UITableViewController,UINavigationControllerDelegate,
        UIImagePickerControllerDelegate {
    
    var ref = Firebase(url: repayFirebaseUrl)
    
    @IBOutlet var barBtnBack: UIBarButtonItem!
    @IBOutlet var btnRequest: UIButton!
    @IBOutlet var imagePreview: UIImageView!
    var imagePicker: UIImagePickerController!
    
    @IBAction func handleRequest(sender: AnyObject) {
        
    }
    
    @IBAction func onCamera(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onRequest(sender: AnyObject) {
        //base64 it
        let imageData = UIImagePNGRepresentation(imagePreview.image!)
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
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
