//
//  LeafResultsViewController.swift
//  App
//
//  Created by wky on 17/9/18.
//  Copyright © 2018 ThREE. All rights reserved.
//

import UIKit

class LeafResultsViewController: UIViewController {


    @IBOutlet weak var treeImage: UIImageView!
    @IBOutlet weak var leafImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    
    var resultsSaved = false
    var typeText = ""
    var confText = ""
    var confColor = UIColor.white
    
    
    
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
        case "planatus":
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
        let ac = UIAlertController(title: nil, message: "Save to library?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { alert in
            
            let renderer = UIGraphicsImageRenderer(size: self.stackView.bounds.size)
            let image = renderer.image { ctx in
                self.stackView.drawHierarchy(in: self.stackView.bounds, afterScreenUpdates: true)
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            
            self.resultsSaved = true
        }))
        
        present(ac, animated: true)
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo info: UnsafeRawPointer) {
        
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
    
    
    
    
    @IBAction func toTreePhoto(_ sender: Any) {
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
    
    
    
    
    private func dismissAndChangeTab() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 0
        
        dismiss(animated: true, completion: nil)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
