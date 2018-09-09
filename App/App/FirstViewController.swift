//
//  FirstViewController.swift
//  App
//
//  Created by wky on 23/8/18.
//  Copyright © 2018 ThREE. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // MARK: - IBOutlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var reqButton: UIButton!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var startOverButton: UIButton!
    
    // Image picker.
    let imagePickerController = UIImagePickerController()
    
    // No. of photos already supplied.
    var currentPhotoNum = 0
    
    // Tapped iamge.
    var tappedImageView = UIImageView()
    var tappedImageViewIndex = 0
    
    // Classification.
    var clfLabel = [""]
    var clfConf = [Float(0)]
    
    
    
    
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Delegate.
        imagePickerController.delegate = self
        
        // Add initial image view.
        addImageView()
    }
    
    
    
    
    // MARK: - IBActions
    
    // Identification and calculation.
    @IBAction func processPhotos(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Use these photos for analysis?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            
            // Find images and classify.
            var n = 0
            for subview in self.stackView.arrangedSubviews {
                if n == self.currentPhotoNum {
                    break
                }
                if type(of: subview) == UIImageView.self {
                    
                    let image = (subview as! UIImageView).image
                    self.classify(image: image!)
                    n += 1
                }
            }
            
            self.performSegue(withIdentifier: "toTreeResults", sender: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(clfLabel, "\n", clfConf)
        if segue.identifier == "toTreeResults" {
            if let des = segue.destination as? UINavigationController {
                if let vc = des.topViewController as? TreeResultsViewController {
                    
                    var maxConf = Float(-1)
                    var type = ""
                    for i in 1...(clfConf.count-1) {
                        if clfConf[i] > maxConf {
                            maxConf = clfConf[i]
                            type = clfLabel[i]
                        }
                    }
                    
                    vc.typeText = type
                    vc.confText = String(Int(maxConf*100))+"%"
                }
            }
        }
    }
    
    // Remove all current photos.
    @IBAction func startOver(_ sender: Any) {
        
        let ac = UIAlertController(title: "Start Over", message: "Discard all current photos?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            
            self.currentPhotoNum = 0
            self.processButton.isHidden = true
            self.startOverButton.isHidden = true
            
            for subview in self.stackView.arrangedSubviews {
                if type(of: subview) == UIImageView.self {
                    self.stackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            }
            
            self.addImageView()
            
            self.clfLabel = [""]
            self.clfConf = [Float(0)]
        }))
        present(ac, animated: true)
    }
    
    // MARK: - Privates
    
    // Add image view to the stack view for new photos.
    private func addImageView() {
        
        // Constraints.
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width
            , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        imageView.addConstraint(widthConstraint)
        imageView.addConstraint(heightConstraint)
        
        if currentPhotoNum == 0 {
            imageView.image = UIImage(named: "Picture1")
        } else {
            imageView.image = UIImage(named: "Picture2")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        stackView.insertArrangedSubview(imageView, at: 2+currentPhotoNum)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        // Tapped image view and its index in the stack.
        tappedImageView = tapGestureRecognizer.view as! UIImageView
        tappedImageViewIndex = stackView.arrangedSubviews.firstIndex(of: tappedImageView)!
        
        // Add new photo or tap on existed photo.
        if tappedImageViewIndex == 2 + currentPhotoNum {
            chooseImage()
        } else {
            showOptions()
        }
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
        let image = tappedImageView.image!
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // Save photo completion.
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {

            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)

        } else {

            let ac = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    private func removePhoto() {
        
        let ac = UIAlertController(title: nil, message: "Remove photo?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            
            self.currentPhotoNum -= 1
    
        self.stackView.removeArrangedSubview(self.tappedImageView)
            self.tappedImageView.removeFromSuperview()
            
            if self.currentPhotoNum == 0 {
                self.processButton.isHidden = true
                self.startOverButton.isHidden = true
            }
            
            if self.currentPhotoNum == 3 {
                self.addImageView()
            }
        }))
        present(ac, animated: true)
    }
    
    private func addBorder(view: UIImageView) {
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    private func removeBorder(view: UIImageView) {
        view.layer.borderWidth = 0
    }
    
    // MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        processButton.isHidden = false
        startOverButton.isHidden = false
        
        addBorder(view: tappedImageView)
        tappedImageView.image = image
        
        // Determine if a new photo is added or an old one changed.
        if tappedImageViewIndex == 2 + currentPhotoNum {
            currentPhotoNum += 1
            if currentPhotoNum < 4 {
                addImageView()
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Image Classification
    
    func classify(image: UIImage) {
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Failed to convert UIImage into CIImage.")
        }
        
        guard let model = try? VNCoreMLModel(for: TreeClassifier().model) else {
            fatalError("Failed to load model.")
        }

        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to load results.")
            }
            
            print(results)
            if let topResult = results.first {
                self.clfLabel.append(topResult.identifier)
                self.clfConf.append(topResult.confidence)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        do {
            try handler.perform([request])
        }
        catch {
            let ac = UIAlertController(title: "Error", message: error.localizedDescription + "\nPlease try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            present(ac, animated: true)
        }
    }
    
    

    
}





// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
