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
        center.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { notification in
            self.authenticationView.centerYConstraint?.constant = -50
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }

        center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { notification in
            self.authenticationView.centerYConstraint?.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    private func configureView() {
        usernameTextField.delegate = self
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
            let username = Username.init(rawValue: usernameText),
            let password = Password.init(rawValue: passwordText) else {
                print("Could not create username or password!")
                return
        }

        let credential = Credential(username: username, password: password)
        User.authenticate(with: credential) { user in
            guard let user = user else {
                print("Could not authenticate user!")
                return
            }
            self.delegate?.didFinishAuthenticating(user: user, in: self)
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
}
