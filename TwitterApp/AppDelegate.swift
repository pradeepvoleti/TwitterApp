//
//  AppDelegate.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 09/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        NotificationCenter.default.addObserver(self, selector: #selector(loggedOut), name: Notification.Name(logoutNotification), object: nil)

        if APIManager.shared.isLoggedIn() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let feedVC = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = feedVC
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        APIManager.shared.handle(url: url)
        return true
    }

    @objc func loggedOut() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateInitialViewController()
        window?.rootViewController = loginVC
    }
}
