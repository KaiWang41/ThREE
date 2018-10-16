//
//  TreeSizeResultsViewController.swift
//  App
//
//  Created by wky on 13/9/18.
//  Copyright © 2018 ThREE. All rights reserved.
//

import UIKit

class TreeSizeResultsViewController: UIViewController {

    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    
    var resultsSaved = false
    var lengthText = "3.4 m × 3.7 m"
    var areaText = "35 m²"
    var sizeText = "69 m³"
    var waterText = "72 L"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lengthLabel.text = lengthText
        areaLabel.text = areaText
        sizeLabel.text = sizeText
        waterLabel.text = waterText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onSave(_ sender: Any) {
        
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
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            }))
            present(ac, animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
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
