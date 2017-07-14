//
//  AuthenticationViewController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/14/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    let authenticationView = AuthenticationView()

    override func loadView() {
        view = authenticationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = NotificationCenter.default
        center.addObserver(forName: .UIKeyboardDidShow, object: nil, queue: nil) { notification in
            self.authenticationView.centerYConstraint?.constant = -50
            print(notification)
        }

        center.addObserver(forName: .UIKeyboardDidHide, object: nil, queue: nil) { notification in
            self.authenticationView.centerYConstraint?.constant = 0
            print(notification)
        }
    }
}
