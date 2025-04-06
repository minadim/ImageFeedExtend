//
//  AppDelegate.swift
//  ImageFeedExtend
//
//  Created by Nadin on 27.01.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Получен редирект: \(url.absoluteString)")
        return true
    }
    
    // MARK: Lifecycle
            
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            // Устанавливаем цвет таббара глобально
            let tabBarAppearance = UITabBar.appearance()
            tabBarAppearance.unselectedItemTintColor = .gray
            tabBarAppearance.tintColor = .white
            tabBarAppearance.barTintColor = UIColor(red: 26/255, green: 27/255, blue: 33/255, alpha: 1)
            tabBarAppearance.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 33/255, alpha: 1)
            tabBarAppearance.isTranslucent = false
            
            return true
        }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

