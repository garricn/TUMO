//
//  AuthenticationView.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/14/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class AuthenticationView: UIView {
    
    let logoimage = UIImage(named: "logo")
    let logoimageview = UIImageView()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let actionButton = UIButton()

    var centerYConstraint: NSLayoutConstraint?

    var buttonWidthConstraint: NSLayoutConstraint?
    var buttonHeightConstraint: NSLayoutConstraint?

    let spinner = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        
        logoimageview.image = logoimage

        addSubview(logoimageview)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(actionButton)

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

        logoimageview.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -10).isActive = true
        logoimageview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        centerYConstraint = passwordTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerYConstraint?.isActive = true

        usernameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -10).isActive = true

        actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        buttonHeightConstraint = actionButton.heightAnchor.constraint(equalToConstant: 50)

    }

    func animateLoginButton() {
        UIView.animate(withDuration: 0.5) {
            self.actionButton.setTitle(nil, for: .normal)
            self.actionButton.backgroundColor = .gray
            self.buttonHeightConstraint?.isActive = true
            self.buttonWidthConstraint?.constant = 50
            self.actionButton.layer.cornerRadius = 25
            self.spinner.startAnimating()
            self.superview?.setNeedsLayout()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

