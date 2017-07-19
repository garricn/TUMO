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

    var errUsername = false
    var errPassword = false
    
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
        
        usernameTextField.delegate = self
        
        usernameTextField.tag = 0
        
        usernameTextField.returnKeyType = UIReturnKeyType.next
        
        passwordTextField.delegate = self
        
        passwordTextField.tag = 1
        
        
        passwordTextField.returnKeyType = UIReturnKeyType.go
        
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
        usernameTextField.autocorrectionType = .no
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        actionButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        actionButton.isEnabled = false
    }
    
    @objc private func didTapLoginButton(sender: UIButton) {
        login()
    }

    private func animateLoginButton() {
        UIView.animate(withDuration: 0.5) {
            self.authenticationView.actionButton.setTitle(nil, for: .normal)
            self.authenticationView.actionButton.backgroundColor = .gray
            self.authenticationView.buttonHeightConstraint?.isActive = true
            self.authenticationView.buttonWidthConstraint?.constant = 50
            self.actionButton.layer.cornerRadius = 25
            self.authenticationView.spinner.startAnimating()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    private func resetLoginButton() {
        UIView.animate(withDuration: 0.5) {
            let title = NSLocalizedString("login", comment: "").uppercased()
            self.authenticationView.actionButton.setTitle(title, for: .normal)
            self.authenticationView.actionButton.backgroundColor = .white
            self.authenticationView.buttonHeightConstraint?.isActive = false
            self.authenticationView.buttonWidthConstraint?.constant = 200
            self.actionButton.layer.cornerRadius = 5
            self.authenticationView.spinner.stopAnimating()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    private func login() {
        animateLoginButton()

        guard let usernameText = usernameTextField.text,
            let passwordText = passwordTextField.text,
            let username = Username(rawValue: usernameText),
            let password = Password(rawValue: passwordText) else {
                return
        }
        
        let credential = Credential(username: username, password: password)

        User.authenticate(with: credential) { [unowned self] user, error in
        
            guard let user = user else {
                if let error = error {
                    switch error {
                    case .invalidPassword:
                        DispatchQueue.main.async {
                            self.passwordTextField.shake()
                            self.passwordTextField.layer.cornerRadius = 5.0
                            self.passwordTextField.layer.masksToBounds = true
                            self.passwordTextField.layer.borderColor = UIColor( red: 255/255, green: 0/255, blue:0/255, alpha:1.0 ).cgColor

                            self.passwordTextField.text = ""
                            self.passwordTextField.layer.borderWidth = 2.0
                            self.passwordTextField.placeholder = "Invalid Password"
                            self.errPassword = true

                        }
                        break
                    case .invalidUsernameAndPassword:
                        self.errUsername = true
                        self.resetLoginButton()
                    case .unknown:
                        fatalError("Network crashed")
                        break
                    }
                } else {
                    print("Unknown error")
                }
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
        if textField.isEqual(usernameTextField) {
            passwordTextField.becomeFirstResponder()
        } else if textField.isEqual(passwordTextField) {
            login()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField {
            let username = Username(rawValue: textField.text!)
            if username == nil{
                textField.shake()
                textField.layer.cornerRadius = 5.0
                textField.layer.masksToBounds = true
                textField.layer.borderColor = UIColor( red: 255/255, green: 0/255, blue:0/255, alpha: 1.0 ).cgColor
                textField.layer.borderWidth = 2.0
                textField.text = ""
                textField.placeholder = NSLocalizedString("Invalid Username", comment: "")
            } else {
                textField.layer.borderWidth = 0.25
                textField.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        
        
        if textField == passwordTextField {
            let password = Password(rawValue: textField.text!)
            if password == nil || errPassword{
                textField.shake()
                textField.layer.cornerRadius = 5.0
                textField.layer.masksToBounds = true
                textField.layer.borderColor = UIColor( red: 255/255, green: 0/255, blue:0/255, alpha: 1.0 ).cgColor
                textField.layer.borderWidth = 2.0
                textField.text = ""
                textField.placeholder = NSLocalizedString("Invalid Password", comment: "")
            } else {
                errPassword = false
                textField.layer.borderWidth = 0.25
                textField.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
}

public extension UIView {
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTranslation translation : Float? = nil) {
        let defaultRepeatCount = 3
        let defaultTotalDuration = 0.2
        let defaultTranslation = -2
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.repeatCount = count ?? Float(defaultRepeatCount)
        animation.duration = (duration ?? defaultTotalDuration)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? defaultTranslation
        layer.add(animation, forKey: "shake")
        
    }    
}







