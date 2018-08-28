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
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var reqButton: UIButton!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var startOverButton: UIButton!
    
    /// Firebase vision instance.
    lazy var vision = Vision.vision()
    
    /// A dictionary holding current results of object detection.
    var results = Dictionary<String, Any>()
    
    /// Image picker.
    let imagePickerController = UIImagePickerController()
    
    /// No. of photos already supplied.
    var currentPhotoNum = 0
    
    /// ID of the currently tapped image view.
    var tappedImageViewId = 0
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Tap geture on images.
        addRecognizer()

        /// Delegate.
        imagePickerController.delegate = self
    }
    
    // MARK: - IBActions
    
    @objc func image1Tapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        tappedImageViewId = 1
        if currentPhotoNum < 1 {
            chooseImage()
        } else {
            showOptions()
        }
    }
    
    @objc func image2Tapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        tappedImageViewId = 2
        if currentPhotoNum < 2 {
            chooseImage()
        } else {
            showOptions()
        }
    }
    
    @IBAction func processPhotos(_ sender: Any) {
        let alert = UIAlertController(title: "Results", message: "The photos indicate that Sicong Ma is a relative SB.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Indeed", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "You are right", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Privates
    
    private func addRecognizer() {
        imageView1.isUserInteractionEnabled = true
        imageView2.isUserInteractionEnabled = true
        imageView3.isUserInteractionEnabled = true
        imageView4.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(image1Tapped(tapGestureRecognizer:)))
        imageView1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(image2Tapped(tapGestureRecognizer:)))
        imageView2.addGestureRecognizer(tapGestureRecognizer2)
    }
    
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
    
    private func showOptions() {
        let actionSheet = UIAlertController(title: "Choose Action", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Change Photo", style: .default, handler: { (action: UIAlertAction)
            in
            
            self.chooseImage()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Save to Library", style: .default, handler: { (action: UIAlertAction)
            in
            
            self.savePhoto()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { (action: UIAlertAction)
            in
            
            self.removePhoto()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func savePhoto() {
        var image: UIImage
        
        switch tappedImageViewId {
        case 1:
            image = imageView1.image!
        case 2:
            image = imageView2.image!
        case 3:
            image = imageView3.image!
        case 4:
            image = imageView4.image!
        default:
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    private func removePhoto() {
        
    }
    
    private func addBorder(view: UIImageView) {
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        processButton.isHidden = false
        startOverButton.isHidden = false
        
        switch tappedImageViewId {
        case 1:
            
            imageView1.image = image
            if currentPhotoNum < 1 {
                addBorder(view: imageView1)
                currentPhotoNum = 1
                imageView2.isHidden = false
            }
            
        case 2:
            
            imageView2.image = image
            if currentPhotoNum < 2 {
                addBorder(view: imageView2)
                currentPhotoNum = 2
                imageView3.isHidden = false
            }
            
        case 3:
            
            imageView3.image = image
            if currentPhotoNum < 3 {
                addBorder(view: imageView3)
                currentPhotoNum = 3
                imageView4.isHidden = false
            }
            
        case 4:
            
            imageView4.image = image
            if currentPhotoNum < 4 {
                addBorder(view: imageView3)
                currentPhotoNum = 4
            }
            
        default:
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
