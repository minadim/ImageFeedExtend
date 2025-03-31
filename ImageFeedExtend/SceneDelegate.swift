//
//  SceneDelegate.swift
//  ImageFeedExtend
//
//  Created by Nadin on 27.01.2025.
//

import UIKit
import SwiftKeychainWrapper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        handleFirstLaunch()
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
    }
    
    private func handleFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "isAppInstalled") == false {
            KeychainWrapper.standard.removeAllKeys()
            UserDefaults.standard.set(true, forKey: "isAppInstalled")
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        print("Получен редирект: \(url.absoluteString)")
        
        if url.scheme == "imagefeedextend" {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let queryItems = components.queryItems {
                if let code = queryItems.first(where: { $0.name == "code" })?.value {
                    print("Код авторизации: \(code)")
                }
            }
        }
    }
}
