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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = {
            let window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window.backgroundColor = .whiteColor()
            window.rootViewController = UINavigationController(rootViewController: ViewController())
            window.makeKeyAndVisible()
            return window
        }()
        return true
    }
}
