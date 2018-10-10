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
import KRProgressHUD

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // MARK: - IBOutlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var startOverButton: UIButton!
    
    // Image picker.
    let imagePickerController = UIImagePickerController()
    
    // No. of photos already supplied.
    var currentPhotoNum = 0
    
    // Tapped iamge.
    var tappedImageView = UIImageView()
    var tappedImageViewIndex = 0
    
    // Classification for each photo.
    var clfLabel = [String]()
    var clfConf = [Float]()
    var clfErr = ""
    
    // Size calculation.
    var surfaceAreas = [CGFloat]()
    var canopySizes = [CGFloat]()
    let trunkCanopyRatio = CGFloat(0.045)
    let meterInchRatio = CGFloat(39.37)
    let gallonLiterRatio = CGFloat(3.7854)
    var calErr = ""
    
    // Text board size in metres.
    let boardWidth: CGFloat = 1.1
    let boardHeight: CGFloat = 0.3
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Delegate.
        imagePickerController.delegate = self
        
        // Add initial image place holder.
        addImageView()
        
        // Button border
        processButton.layer.cornerRadius = 5
        calculateButton.layer.cornerRadius = 5
        startOverButton.layer.cornerRadius = 5
    }
    
    
    
    
    
    // Add image view to the stack view for new photos.
    func addImageView() {
        
        // Constraints.
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width
            , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        imageView.addConstraint(widthConstraint)
        imageView.addConstraint(heightConstraint)
        imageView.image = UIImage(named: "Picture1")

        
        // Add tap gesture to every photo.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        // Add to stack view.
        stackView.insertArrangedSubview(imageView, at: 2+currentPhotoNum)
    }
    
    
    
    
    // Image tapped.
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
    
    
    
    
    // Add new photo.
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
    
    
    
    
    // Image picker delegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        Utilities.presentLoader()
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        
        // Only show buttons when there is at least one photo.
        processButton.isHidden = false
        calculateButton.isHidden = false
        startOverButton.isHidden = false

        tappedImageView.image = image
        
        // Determine if a new photo is added or an old one changed and update the number.
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
    
    
    // Tap on existing photo.
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
    
    
    
    // Save photo to library.
    private func savePhoto() {
        let image = tappedImageView.image!
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            Utilities.presentError(message: "Save Failed")
            
        } else {
            Utilities.presentSuccess(message: "Saved")
        }
    }
    
    
    
    // Delete certain photo.
    private func removePhoto() {

        Utilities.presentLoader()
        
        self.currentPhotoNum -= 1
        
        self.stackView.removeArrangedSubview(self.tappedImageView)
        self.tappedImageView.removeFromSuperview()
        
        // If no photo left, hide buttons.
        if self.currentPhotoNum == 0 {
            self.processButton.isHidden = true
            self.startOverButton.isHidden = true
            self.calculateButton.isHidden = true
        }
        
        if self.currentPhotoNum == 3 {
            self.addImageView()
        }

    }
    
    
    

    // Identification and calculation.
    
    @IBAction func processPhotos(_ sender: Any) {
        
        // Clear previous results
        clfLabel.removeAll()
        clfConf.removeAll()
        surfaceAreas.removeAll()
        canopySizes.removeAll()
        clfErr = ""
        calErr = ""
        
        // Present alert based on tapped button.
        let message = ((sender as! UIButton) == processButton) ? "Use these photos for type identification?" : "Use these photos for size calculation?"
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in

            if (self.processButton == (sender as! UIButton)) {
                
                self.classify()
                
                // If classification failed
                if self.clfErr == "" {
                    self.performSegue(withIdentifier: "toTreeResults", sender: nil)
                } else {
                    Utilities.presentErrorAlert(sender: self, message: self.clfErr)
                }
            } else {

                self.calculate()
                
                // Calculation failed
                if self.calErr == "" {
                    self.performSegue(withIdentifier: "toSizeResults", sender: nil)
                } else {
                    Utilities.presentErrorAlert(sender: self, message: self.calErr)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    

    
    
    
    
    
    
    
    
    
    // MARK: - Image Classification
    
    func classify() {
        
        guard let model = try? VNCoreMLModel(for: Tree().model) else {
            clfErr = "Model error. Please try again."
            return
        }
        
        // Find images in stack view and process accordingly.
        // Keep count of processed photos.
        var n = 0
        for subview in self.stackView.arrangedSubviews {
            
            // All photos processed.
            if n == self.currentPhotoNum {
                break
            }
            
            // Find image views.
            if type(of: subview) == UIImageView.self {
                
                n += 1
                
                let image = (subview as! UIImageView).image
                    
                guard let ciImage = CIImage(image: image!) else {
                    clfErr = "The image has no CIImage backing it."
                    return
                }
        
                let request = VNCoreMLRequest(model: model) { (request, error) in
                    guard let results = request.results as? [VNClassificationObservation] else {
                        self.clfErr = "Observation error. Please try again."
                        return
                    }
                    
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
                    clfErr = error.localizedDescription
                    return
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // Mark: - Size Calculation

    func calculate() {
        var n = 0
        for subview in self.stackView.arrangedSubviews {
        
            if n == self.currentPhotoNum {
                break
            }
            
            if type(of: subview) == UIImageView.self {
                
                n += 1
                let image = (subview as! UIImageView).image
                
                // Convert from UIImageOrientation to CGImagePropertyOrientation.
                let cgOrientation = CGImagePropertyOrientation(image!.imageOrientation)
                
                guard let cgImage = image!.cgImage else {
                    calErr = "No CIImage"
                    return
                }
                
                let request = VNDetectTextRectanglesRequest(completionHandler: { (request, error) in
                    
                    guard let results = request.results as? [VNTextObservation] else {
                        self.calErr = "Observation error. Please try again."
                        return
                    }
                    
                    // Make sure there is only one text observation with 4 characters - "TREE".
                    
                    var count = 0
                    var targetObservation: VNTextObservation?
                    for result in results {
                        if let n = result.characterBoxes?.count {
                            
                            if n == 4 {
                                count += 1
                                targetObservation = result
                            }
                        }
                    }
                    if count != 1 {
                        self.calErr = "Failed to detect text board. Please make sure it is clearly visible. Avoid other texts in photo."
                        return
                    }
                    
                    // Get text observation bounding and scale.
                    if let box = targetObservation?.boundingBox {
                        
                        // Image size in metres.
                        let imageWidthInMeters = self.boardWidth / box.size.width
                        let imageHeightInMeters = self.boardHeight / box.size.height
                        
                        let (area, size) = self.calculateAreaAndSize(image: cgImage, width: imageWidthInMeters, height: imageHeightInMeters)
                        
                        self.canopySizes.append(size)
                        self.surfaceAreas.append(area)
                    }
                })
                request.reportCharacterBoxes = true
                
                let handler = VNImageRequestHandler(cgImage: cgImage, orientation: cgOrientation)
                
                do {
                    try handler.perform([request])
                }
                catch {
                    calErr = "Image detection error. Please try again."
                    return
                }
            }
        }
    }
    
        
    
    
    // Calculate area and size.
    // The shape of tree assumed to be a cylinder for each row of green pixels.
    private func calculateAreaAndSize(image: CGImage, width: CGFloat, height: CGFloat) -> (CGFloat, CGFloat) {
        
        let pixelData = image.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        // Determine if a pixel is green.
        func isGreen(x: Int, y: Int) -> Bool {
            
            let pixelInfo: Int = (image.width * y + x) * 4
            let red = data[pixelInfo]
            let green = data[pixelInfo + 1]
            let blue = data[pixelInfo + 2]
            
            if (green >= 20) && (red < 140) && (red < green) && (blue < green/2) {
                return true
            } else {
                return false
            }
        }
        
        var area: CGFloat = 0
        var size: CGFloat = 0
        
        // Count green pixels for each row.
        
        for y in 0..<image.height {
            
            var count = 0
            for x in 0..<image.width {
                
                // If a green pixel is not adjacent to any other green one, it is not included.
                var isLeaf = false
                if isGreen(x: x, y: y) {
                    
                    // Same column.
                    if y >= 1 {
                        if isGreen(x: x, y: y-1) {
                            // Found adjacent green.
                            isLeaf = true
                        }
                    }
                    if y+1 < image.height {
                        if isGreen(x: x, y: y+1) {
                            isLeaf = true
                        }
                    }
                    
                    
                    // Left column.
                    if x >= 1 {
                        if isGreen(x: x-1, y: y) {
                            isLeaf = true
                        }
                        if y >= 1 {
                            if isGreen(x: x-1, y: y-1) {
                                isLeaf = true
                            }
                        }
                        if y+1 < image.height {
                            if isGreen(x: x-1, y: y+1) {
                                isLeaf = true
                            }
                        }
                    }
                    
                    // Right column.
                    if x+1 < image.width {
                        if isGreen(x: x+1, y: y) {
                            isLeaf = true
                        }
                        if y >= 1 {
                            if isGreen(x: x+1, y: y-1) {
                                isLeaf = true
                            }
                        }
                        if y+1 < image.height {
                            if isGreen(x: x+1, y: y+1) {
                                isLeaf = true
                            }
                        }
                    }
                }
                
                if isLeaf {
                    count += 1
                }
            }
            
            // Calculation.
            let diameter = (CGFloat(count) / CGFloat(image.width)) * width
            let pixelHeight = (CGFloat(1) / CGFloat(image.height)) * height
            size += CGFloat.pi * diameter * diameter / 4 * pixelHeight
            area += CGFloat.pi * diameter * pixelHeight
        }
        
        return (area, size)
    }
    
    
    
    
    // Prepare for result segues.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Type ID.
        if segue.identifier == "toTreeResults" {
            if let des = segue.destination as? UINavigationController {
                if let vc = des.topViewController as? TreeResultsViewController {
                    
                    var maxConf = Float(-1)
                    var type = ""
                    for i in 0..<currentPhotoNum {
                        if clfConf[i] > maxConf {
                            maxConf = clfConf[i]
                            type = clfLabel[i]
                        }
                    }
                    
                    vc.typeText = type
                    vc.confText = String(Int(maxConf*100))+"%"
                    
                    // Confidence label color
                    if maxConf > 2.0/3.0 {
                        vc.confColor = UIColor.blue
                    } else if maxConf > 1.0/3.0 {
                        vc.confColor = UIColor.purple
                    } else {
                        vc.confColor = UIColor(red: 128/255, green: 0, blue: 0, alpha: 1)
                    }

                }
            }
        }
        
        // Size calculation.
        if segue.identifier == "toSizeResults" {
            let vc = (segue.destination as! UINavigationController).topViewController as! TreeSizeResultsViewController
            
            func getAvg(_ a: [CGFloat]) -> CGFloat {
                var sum = CGFloat(0)
                for el in a {
                    sum += el
                }
                return sum/CGFloat(a.count)
            }
            
            // Average over all photos.
            let avgArea = getAvg(surfaceAreas)
            let avgSize = getAvg(canopySizes)
            let water = (avgArea / 4 / CGFloat.pi).squareRoot() * 2 * trunkCanopyRatio * meterInchRatio * 10 * gallonLiterRatio
            vc.areaText = String(Int(avgArea)) + " m²"
            vc.sizeText = String(Int(avgSize)) + " m³"
            vc.waterText = String(Int(water)) + " L p/w"
        }
    }
    
    
    
    
    
    
    
    // Remove all current photos.
    @IBAction func startOver(_ sender: Any) {
        
        let ac = UIAlertController(title: "Start Over", message: "Discard all current photos?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            
            Utilities.presentLoader()
            self.currentPhotoNum = 0
            self.processButton.isHidden = true
            self.startOverButton.isHidden = true
            self.calculateButton.isHidden = true
            
            for subview in self.stackView.arrangedSubviews {
                if type(of: subview) == UIImageView.self {
                    self.stackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            }
            
            
            // Add back the initial placeholder.
            self.addImageView()
        }))
        present(ac, animated: true)
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
