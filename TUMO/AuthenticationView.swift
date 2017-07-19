//
//  AuthenticationView.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/14/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class AuthenticationView: UIView {
    
    let logoimage = UIImage(named: NSLocalizedString("logo", comment: ""))
    let logoimageview = UIImageView()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let actionButton = UIButton()

    var centerYConstraint: NSLayoutConstraint?

    var buttonWidthConstraint: NSLayoutConstraint?
    var buttonHeightConstraint: NSLayoutConstraint?

    let spinner = UIActivityIndicatorView()
    
    private let logoContainerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        
        logoimageview.image = logoimage
        
        addSubview(logoContainerView)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(actionButton)

        logoContainerView.addSubview(logoimageview)
        logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        logoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        logoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        logoContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        logoContainerView.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor).isActive = true
        
        logoimageview.leadingAnchor.constraint(equalTo: logoContainerView.leadingAnchor, constant: 65).isActive = true
        logoimageview.trailingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: -65).isActive = true
        logoimageview.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor).isActive = true
        
        
        logoimageview.contentMode = .scaleAspectFit
        logoimageview.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        usernameTextField.placeholder = NSLocalizedString("username", comment: "").capitalized
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.none
        
        usernameTextField.layer.borderColor = UIColor.gray.cgColor

        passwordTextField.placeholder = NSLocalizedString("password", comment: "").capitalized
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.isSecureTextEntry = true
        
        actionButton.setTitle(NSLocalizedString("login", comment: "").uppercased(), for: .normal)
        actionButton.setTitleColor(.gray, for: .normal)
        actionButton.setTitleColor(.gray, for: .highlighted)
        actionButton.backgroundColor = .white
        actionButton.layer.borderColor = UIColor.gray.cgColor
        actionButton.layer.borderWidth = 2.0
        actionButton.layer.cornerRadius = 5.0

        spinner.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor).isActive = true

        usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true

        passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true

        buttonWidthConstraint = actionButton.widthAnchor.constraint(equalToConstant: 200)
        buttonWidthConstraint?.isActive = true
        
        centerYConstraint = passwordTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerYConstraint?.isActive = true

        usernameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -10).isActive = true

        actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        buttonHeightConstraint = actionButton.heightAnchor.constraint(equalToConstant: 50)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
