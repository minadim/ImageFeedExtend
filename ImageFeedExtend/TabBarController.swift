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
        tabBar.barTintColor = UIColor(red: 26/255, green: 27/255, blue: 33/255, alpha: 1)
        tabBar.isTranslucent = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else {
            assertionFailure("Не удалось найти ImagesListViewController по идентификатору")
            return
        }
        
        let presenter = ImagesListPresenter()
        imagesListViewController.configure(presenter)
        
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
