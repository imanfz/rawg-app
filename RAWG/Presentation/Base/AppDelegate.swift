//
//  AppDelegate.swift
//  RAWG
//
//  Created by Iman Faizal on 06/06/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if !UserDefaults.standard.bool(forKey: "photos") &&
            !UserDefaults.standard.bool(forKey: "name") &&
            !UserDefaults.standard.bool(forKey: "email") {
            ProfileModel.photos = (UIImage(named: "my_photos")?.pngData())!
            ProfileModel.name = "Iman Faizal"
            ProfileModel.email = "imanfz1103@gmail.com"
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
