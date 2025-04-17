//
//  ProfileProtocols.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

import Foundation
import UIKit

public protocol ProfileViewProtocol: AnyObject {
    func updateProfile(name: String, username: String, bio: String)
    func updateAvatar(url: URL)
    func showLogoutAlert()
    func resetToSplashScreen()
}

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
    func confirmLogout()
}
