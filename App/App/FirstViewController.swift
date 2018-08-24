//
//  FirstViewController.swift
//  App
//
//  Created by wky on 23/8/18.
//  Copyright © 2018 ThREE. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    /// Firebase vision instance.
    lazy var vision = Vision.vision()
    
    /// A dictionary holding current results from detection.
    var results = Dictionary<String, Any>()
    
    /// Image picker
    let imagePickerController = UIImagePickerController()
    
    /// No. of photos supplied
    var currentPhotoNum = 0
    
    /// ID of the tapped image view
    var tappedImageViewId = 0
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Tap geture on images
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView1.isUserInteractionEnabled = true
        imageView1.addGestureRecognizer(tapGestureRecognizer)
        
        imagePickerController.delegate = self
    }
    
    func updateStatus() {
    
    }
    
    // MARK: - IBActions

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImageView = tapGestureRecognizer.view as! UIImageView
        
        switch tappedImageView {
        case imageView1:
            
            tappedImageViewId = 1
            if currentPhotoNum == 0 {
                chooseImage()
            }
        
        default:
            return
        }
    }
    
    // MARK: - Privates
    
    private func chooseImage() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction)
            in
            
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.showsCameraControls = true
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction)
            in
            
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func addImageView(id: Int) {
//        switch id {
//        case 2:
//
//        default:
//            return
//        }
    }

    // MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        switch tappedImageViewId {
        case 1:
            imageView1.layer.borderWidth = 10
            imageView1.layer.borderColor = UIColor.black.cgColor
            imageView1.image = image
            addImageView(id: 2)
        default:
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
