//
//  Utilities.swift
//  App
//
//  Created by wky on 13/9/18.
//  Copyright © 2018 ThREE. All rights reserved.
//

import UIKit
import KRProgressHUD

class Utilities: NSObject {

    static func presentError(message: String) {
        if message != "" {
            KRProgressHUD.showError(withMessage: message)
        } else {
            KRProgressHUD.showError()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            KRProgressHUD.dismiss()
        }
    }
    
    static func presentSuccess(message: String) {
        if message != "" {
            KRProgressHUD.showSuccess(withMessage: message)
        } else {
            KRProgressHUD.showSuccess()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            KRProgressHUD.dismiss()
        }
    }
    
    static func presentLoader() {
        KRProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            KRProgressHUD.dismiss()
        }
    }
    
    static func presentErrorAlert(sender: UIViewController, message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        sender.present(ac, animated: true)
    }

}
