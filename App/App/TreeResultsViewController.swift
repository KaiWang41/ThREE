//
//  TreeResultsViewController.swift
//  App
//
//  Created by wky on 7/9/18.
//  Copyright © 2018 ThREE. All rights reserved.
//

import UIKit

class TreeResultsViewController: UIViewController {

    @IBOutlet weak var treeImage: UIImageView!
    @IBOutlet weak var leafImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!

    // Values passed from segue.
    var resultsSaved = false
    var typeText = ""
    var confText = ""
    var confColor = UIColor.white
    
    
    // Set texts based on segue.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        typeLabel.text = typeText
        confidenceLabel.text = confText
        confidenceLabel.textColor = confColor
        
        // Configure sample image
        typeText = typeText.lowercased()
        treeImage.image = UIImage(named: typeText)
        let leafText = typeText + "_leaf"
        leafImage.image = UIImage(named: leafText)
        
        // Common names
        switch typeText {
        case "platanus":
            typeLabel.text = "Plane Tree"
        case "ulmus":
            typeLabel.text = "Elm Tree"
        case "corymbia":
            typeLabel.text = "Gum Tree"
        case "quercus":
            typeLabel.text = "Oak"
        default:
            ()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func onSave(_ sender: Any) {

            // Save the view as image.
            let renderer = UIGraphicsImageRenderer(size: self.stackView.bounds.size)
            let image = renderer.image { ctx in
                self.stackView.drawHierarchy(in: self.stackView.bounds, afterScreenUpdates: true)
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo info: UnsafeRawPointer) {
        
        if let _ = error {
            
            Utilities.presentError(message: "Save Error")
            
        } else {
            Utilities.presentSuccess(message: "Saved")
            self.resultsSaved = true
        }
    }
    
    @IBAction func onDone(_ sender: Any) {
        if !resultsSaved {
            let ac = UIAlertController(title: nil, message: "Close without saving?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
                
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(ac, animated: true)
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func toLeafPhoto(_ sender: Any) {
        if !resultsSaved {
            let ac = UIAlertController(title: nil, message: "Close without saving?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
                
                self.dismissAndChangeTab()
            }))
            
            present(ac, animated: true)
            
        } else {
            dismissAndChangeTab()
        }
    }
    
    // Close and go to another tab.
    private func dismissAndChangeTab() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 1
        
        dismiss(animated: true, completion: nil)
    }
}
