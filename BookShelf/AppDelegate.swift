//
//  AppDelegate.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/14.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMobileAds
import FirebaseCore
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.userInterfaceStyle
        IQKeyboardManager.shared.enable = true
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()
        return true
    }
    
    
}

