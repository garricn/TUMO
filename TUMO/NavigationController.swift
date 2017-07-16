//
//  NavigationController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/15/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, AuthenticationDelegate, MyScheduleViewControllerDelegate {

    var user: User? {
        didSet {
            if let user = user {
                User.archive(user)
            } else {
                User.remove()
            }

            setup()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }

    func setup() {
        if let user = user {
            let viewController = MyScheduleViewController(user: user, workshops: Workshop.unarchived)
            viewController.delegate = self
            setViewControllers([viewController], animated: false)
        } else {
            let viewController = AuthenticationViewController()
            viewController.delegate = self
            viewControllers.first?.present(viewController, animated: true) {
                let viewController = UIViewController()
                viewController.view.backgroundColor = .white
                self.setViewControllers([viewController], animated: false)
            }
        }
    }

    // MARK: - Authentication Delegate

    func didFinishAuthenticating(user: User, in viewController: UIViewController) {
        self.user = user
        viewController.dismiss(animated: true, completion: nil)
    }

    // MARK: - MySchedule ViewController Delegate

    func didTapLogOutButton(in viewController: UIViewController) {
        user = nil
        Workshop.removeAll()
    }
}
