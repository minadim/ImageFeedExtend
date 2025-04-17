//
//  Untitled.swift
//  ImageFeedExtend
//
//  Created by Nadin on 13.04.2025.
//

import Foundation
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        updateProfileDetails()
        subscribeToAvatarUpdates()
        updateAvatar()
    }
    
    func didTapLogout() {
        view?.showLogoutAlert()
    }
    
    func confirmLogout() {
        tokenStorage.token = nil
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        view?.resetToSplashScreen()
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else {
            print("Ошибка: профиль отсутствует")
            return
        }
        view?.updateProfile(
            name: profile.name,
            username: profile.loginName,
            bio: profile.bio ?? "Нет описания" 
        )
    }
    
    private func subscribeToAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateAvatar()
            }
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else {
            return
        }
        view?.updateAvatar(url: url)
    }
}
