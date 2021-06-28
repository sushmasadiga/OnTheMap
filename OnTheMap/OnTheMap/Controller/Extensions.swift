//
//  Extensions.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 29/06/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated:true)
    }
    
    func showFindLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Find Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated:true)
    }
    
    func showFailure(failureType: String, message: String) {
        let alertVC = UIAlertController(title: failureType, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated:true)
    }
    
}
