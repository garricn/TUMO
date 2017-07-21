//
//  AppDelegate.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/11/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        let navigationController = NavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
