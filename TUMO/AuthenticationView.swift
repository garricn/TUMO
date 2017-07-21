//
//  AuthenticationView.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/14/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class AuthenticationView: UIView {

//    let infoLabel = UILabel()
    
    let logoimage = UIImage(named: "logo")
    let logoimageview = UIImageView()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let actionButton = UIButton()

    var centerYConstraint: NSLayoutConstraint?

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        
        logoimageview.image = logoimage
        
//        addSubview(infoLabel)
        addSubview(logoimageview)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(actionButton)

        //infoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoimageview.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        //infoLabel.text = "TUMO"
        //infoLabel.textAlignment = .center

        usernameTextField.placeholder = NSLocalizedString("username", comment: "").capitalized
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.none
        
        usernameTextField.layer.borderColor = UIColor.gray.cgColor

        passwordTextField.placeholder = NSLocalizedString("password", comment: "").capitalized
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.isSecureTextEntry = true
        
        actionButton.setTitle(NSLocalizedString("login", comment: "").uppercased(), for: .normal)
        actionButton.setTitleColor(.blue, for: .normal)
        actionButton.setTitleColor(.gray, for: .highlighted)
        actionButton.backgroundColor = .white
        actionButton.layer.borderColor = UIColor.blue.cgColor
        actionButton.layer.borderWidth = 2.0
        actionButton.layer.cornerRadius = 5.0

        // MARK: - Constraining X Axis

        //infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        //infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true

        passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true

        actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70).isActive = true

        // MARK: - Constraining Y Axis

        logoimageview.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -10).isActive = true
        logoimageview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        centerYConstraint = passwordTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerYConstraint?.isActive = true

        //infoLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -10).isActive = true
        usernameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -10).isActive = true
        actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

