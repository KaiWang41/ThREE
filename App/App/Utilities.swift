//
//  Utilities.swift
//  App
//
//  Created by wky on 13/9/18.
//  Copyright © 2018 ThREE. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    static func presentAlert(for vc: UIViewController, type: String, message: String) {
        
        let title = (type == "error") ? "Error" : ""
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch type {
        case "error":
            ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        case "info":
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        default:
            ()
        }
        
        vc.present(ac, animated: true)
    }
}
