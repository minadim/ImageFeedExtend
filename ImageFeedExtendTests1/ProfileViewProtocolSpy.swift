//
//  Untitled.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

@testable import ImageFeedExtend
import Foundation

// MARK: - Мок представления
   final class ViewSpy: ProfileViewProtocol {
       private(set) var didCallUpdateProfile = false
       private(set) var didCallUpdateAvatar = false
       private(set) var didCallShowLogoutAlert = false
       private(set) var didCallResetToSplashScreen = false

       func updateProfile(name: String, username: String, bio: String) {
           didCallUpdateProfile = true
       }

       func updateAvatar(url: URL) {
           didCallUpdateAvatar = true
       }

       func showLogoutAlert() {
           didCallShowLogoutAlert = true
       }

       func resetToSplashScreen() {
           didCallResetToSplashScreen = true
       }
   }
   
  
