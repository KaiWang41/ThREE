//
//  RequirementViewController.swift
//  App
//
//  Created by wky on 27/8/18.
//  Copyright © 2018 ThREE. All rights reserved.
//

import UIKit

class RequirementViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.layer.borderWidth = 10
        image.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func pressDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
