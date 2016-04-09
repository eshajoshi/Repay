//
//  UploadViewController.swift
//  Repay
//
//  Created by Kevin Vincent on 4/9/16.
//  Copyright © 2016 Esha Joshi. All rights reserved.
//

import UIKit

class UploadViewController:
    UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var btnRequest: UIButton!
    @IBOutlet var imagePreview: UIImageView!
    var imagePicker: UIImagePickerController!
    
    @IBAction func onCamera(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onRequest(sender: AnyObject) {
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePreview.contentMode = UIViewContentMode.ScaleAspectFit;
        imagePreview.image = image;
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        btnRequest.backgroundColor = UIColor.groupTableViewBackgroundColor();
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: {
            
        })
    }

}
