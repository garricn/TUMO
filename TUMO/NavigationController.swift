//
//  NavigationController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/15/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, AuthenticationDelegate, MyScheduleViewControllerDelegate {

    private var user: User? = User.unarchived {
        didSet {
            if let user = user {
                User.archive(user)
            } else {
                User.remove()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }

    private func setup() {
        if let user = user {
            let viewController = MyScheduleViewController(user: user)
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
        setup()
        viewController.dismiss(animated: true, completion: nil)
    }

    // MARK: - MyScheduleViewController Delegate

    func didTapLogOutButton(in viewController: MyScheduleViewController) {
        user = nil
        setup()
    }

    func didPullToRefresh(in viewController: MyScheduleViewController) {
        guard let user = user else { return }

        User.fetchWorkshops(for: user) { workshops in
            DispatchQueue.main.async {
                // Store new user
                self.user = User(id: user.id,
                                 name: user.name,
                                 workshops: workshops ?? [],
                                 password: user.password,
                                 username: user.username
                )
                
                // Inject new user into My schedule view controller
                viewController.user = self.user!
            }
        }
    }
}
