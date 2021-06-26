//
//  LoginButton.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryLight
    }
    
}
