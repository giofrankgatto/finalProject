//
//  ReportIssueViewController.swift
//  finalProject
//
//  Created by Giovanni Gatto on 11/30/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import UIKit

class ReportIssueViewController: UIViewController, UIImagePickerControllerDelegate {
    


    //MARK: - Camera Methods
    
    
    @IBAction func cameraButtonTapped (sender: UIBarButtonItem) {
        print("Camera button Tapped")
        let imagePicker = UIImagePickerController()
        if imagePicker.sourceType == UIImagePickerControllerSourceType.Camera {
        [self .presentViewController(imagePicker, animated: true, completion: nil)]
        } else {
        print("Warning - no camera")
        }
    }

    
    @IBAction func galleryButtonTapped (sender: UIBarButtonItem) {
        print("Gallery Button Tapped")
        let imagePicker = UIImagePickerController()
        if imagePicker.sourceType == UIImagePickerControllerSourceType.SavedPhotosAlbum {
            [self .presentViewController(imagePicker, animated: true, completion: nil)]
        } else {
            print("No gallery")
        }
    }
    
   
    
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
}
