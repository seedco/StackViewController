//
//  AppDelegate.swift
//  Example
//
//  Created by Indragie Karunaratne on 2016-04-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .white
            window.rootViewController = UINavigationController(rootViewController: ViewController())
            window.makeKeyAndVisible()
            return window
        }()
        return true
    }
}
