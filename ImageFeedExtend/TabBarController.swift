//
//  TabBarController.swift
//  ImageFeedExtend
//
//  Created by Nadin on 21.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarController загружен!")
        
        // MARK: - Private Methods
        
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = .white
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active")?.withRenderingMode(.alwaysTemplate),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active")?.withRenderingMode(.alwaysTemplate),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

