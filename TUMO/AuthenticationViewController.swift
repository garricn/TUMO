//
//  AuthenticationViewController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/14/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate {

    let authenticationView = AuthenticationView()

    override func loadView() {
        view = authenticationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardObservers()
        configureView()
    }

    func configureView() {
        authenticationView.usernameTextField.delegate = self
        authenticationView.passwordTextField.delegate = self
        authenticationView.actionButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        authenticationView.actionButton.isEnabled = false
    }

    func didTapLoginButton(sender: UIButton) {
        // validation
        // authenticate
        // success or failure
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        authenticationView.actionButton.isEnabled = !authenticationView.passwordTextField.text!.isEmpty
            && !authenticationView.usernameTextField.text!.isEmpty
        return true
    }

    func configureKeyboardObservers() {
        let center = NotificationCenter.default
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
}
