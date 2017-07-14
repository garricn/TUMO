//
//  AuthenticationView.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/14/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class AuthenticationView: UIView {

    let infoLabel = UILabel()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let actionButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(infoLabel)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(actionButton)

        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        infoLabel.text = "TUMO"
        infoLabel.textAlignment = .center

        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect

        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
