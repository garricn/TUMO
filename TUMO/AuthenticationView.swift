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

    var centerYConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

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

        actionButton.setTitle("LOGIN", for: .normal)
        actionButton.setTitleColor(.blue, for: .normal)
        actionButton.setTitleColor(.gray, for: .highlighted)
        actionButton.backgroundColor = .white
        actionButton.layer.borderColor = UIColor.blue.cgColor
        actionButton.layer.borderWidth = 2.0
        actionButton.layer.cornerRadius = 5.0

        // MARK: - Constraining X Axis

        infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true

        passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true

        actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70).isActive = true

        // MARK: - Constraining Y Axis

        centerYConstraint = passwordTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerYConstraint?.isActive = true

        infoLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -10).isActive = true
        usernameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -10).isActive = true
        actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
