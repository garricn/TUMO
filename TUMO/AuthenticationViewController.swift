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
}
