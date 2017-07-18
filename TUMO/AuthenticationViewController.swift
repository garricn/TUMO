//
//  AuthenticationViewController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/14/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

protocol AuthenticationDelegate: class {
    func didFinishAuthenticating(user: User, in viewController: UIViewController)
}

class AuthenticationViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: AuthenticationDelegate?

    let authenticationView = AuthenticationView()
    let center = NotificationCenter.default

    var usernameTextField: UITextField {
        return authenticationView.usernameTextField
    }

    var passwordTextField: UITextField {
        return authenticationView.passwordTextField
    }

    var actionButton: UIButton {
        return authenticationView.actionButton
    }

    deinit {
        center.removeObserver(self)
    }

    override func loadView() {
        view = authenticationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardObservers()
        configureView()
    }

    private func configureKeyboardObservers() {
        center.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { [weak self] notification in
            self?.authenticationView.centerYConstraint?.constant = -50
            UIView.animate(withDuration: 0.5) {
                self?.view.layoutIfNeeded()
            }
        }

        center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { [weak self] notification in
            self?.authenticationView.centerYConstraint?.constant = 0
            UIView.animate(withDuration: 0.5) {
                self?.view.layoutIfNeeded()
            }
        }
    }

    private func configureView() {
        usernameTextField.delegate = self
        usernameTextField.tag = 0
        usernameTextField.returnKeyType = UIReturnKeyType.next
        passwordTextField.tag = 1
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.delegate = self
        actionButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        actionButton.isEnabled = false
    }

    @objc private func didTapLoginButton(sender: UIButton) {
        login()
    }

    private func login() {
        guard let usernameText = usernameTextField.text,
            let passwordText = passwordTextField.text,
            let username = Username(rawValue: usernameText),
            let password = Password(rawValue: passwordText) else {
                return
        }
        
        let credential = Credential(username: username, password: password)

        User.authenticate(with: credential) { [unowned self] user in
            guard let user = user else {
                print("Could not authenticate user!")
                return
            }
            DispatchQueue.main.async {
                self.delegate?.didFinishAuthenticating(user: user, in: self)
            }
        }
    }

    // MARK: - UITextField Delegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        actionButton.isEnabled = !passwordTextField.text!.isEmpty
            && !usernameTextField.text!.isEmpty
        return true
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        login()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField {
            let username = Username(rawValue: textField.text!)
            if username == nil {
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: cgPointMake(textField.center.x - 10, textField.center.y))
                animation.toValue = NSValue(cgPoint: cgPointMake(textField.center.x + 10, textField.center.y))
                textField.layer.add(animation, forKey: "position")
                
                
                textField.layer.cornerRadius = 5.0
                textField.layer.masksToBounds = true
                textField.layer.borderColor = UIColor( red: 255/255, green: 0/255, blue:0/255, alpha: 1.0 ).cgColor
                textField.layer.borderWidth = 2.0
                textField.text = ""
                textField.placeholder = "Invalid Username"
            } else {
                textField.layer.borderWidth = 0.25
                textField.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        
        if textField == passwordTextField {
            let password = Password(rawValue: textField.text!)
            if password == nil {
                textField.layer.cornerRadius = 5.0
                textField.layer.masksToBounds = true
                textField.layer.borderColor = UIColor( red: 255/255, green: 0/255, blue:0/255, alpha: 1.0 ).cgColor
                textField.layer.borderWidth = 2.0
                textField.text = ""
                textField.placeholder = "Invalid Password"
            } else {
                textField.layer.borderWidth = 0.25
                textField.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
}








