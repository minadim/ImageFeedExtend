//
//  ProfileViewTest.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

import Testing

@testable import ImageFeedExtend
import XCTest

final class ProfileViewControllerTests: XCTestCase {
    
    func testViewDidLoad_CallsPresenterViewDidLoad() {
        let sut = ProfileViewController()
        let presenter = PresenterSpy()
        sut.configure(presenter)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoadCalled, "viewDidLoad() у presenter должен быть вызван")
    }
    
    func testExitButtonTap_CallsDidTapLogout() {
        let sut = ProfileViewController()
        let presenter = PresenterSpy()
        sut.configure(presenter)
        sut.loadViewIfNeeded()
        
        let button = sut.view.subviews.compactMap { $0 as? UIButton }.first
        button?.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(presenter.didTapLogoutCalled, "didTapLogout() должен быть вызван при нажатии кнопки выхода")
    }
    
    func testUpdateProfile_UpdatesUILabels() {
        let sut = ProfileViewController()
        let presenter = PresenterSpy()
        sut.configure(presenter)
        sut.loadViewIfNeeded()
        
        sut.updateProfile(name: "Тест", username: "@test", bio: "Bio")
        
        let nameLabel = sut.view.subviews.compactMap { $0 as? UILabel }.first(where: { $0.font.pointSize == 23 })
        XCTAssertEqual(nameLabel?.text, "Тест")
    }
    
    func testShowLogoutAlert_PresentsAlertController() {
        let sut = ProfileViewController()
        let presenter = PresenterSpy()
        sut.configure(presenter)
        sut.loadViewIfNeeded()
        
        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        sut.showLogoutAlert()
        
        RunLoop.current.run(until: Date())
        
        let presentedVC = sut.presentedViewController as? UIAlertController
        XCTAssertNotNil(presentedVC)
        XCTAssertEqual(presentedVC?.title, "Пока, пока!")
    }
}

// MARK: - Тесты для ProfilePresenter

final class ProfilePresenterTests: XCTestCase {
    
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
    
    override func setUp() {
        super.setUp()
        OAuth2TokenStorage().token = "dummy_token"
    }
    
    override func tearDown() {
        OAuth2TokenStorage().token = nil
        super.tearDown()
    }
    
    func testViewDidLoad_CallsUpdateProfileAndAvatar() {
        let result = ProfileResult(
            username: "test_user",
            first_name: "Тест",
            last_name: "Пользователь",
            bio: "Test bio"
        )
        
        let profile = Profile(profileResult: result)
        
        ProfileService.shared.profile = profile
        
        ProfileImageService.shared.avatarURL = "https://example.com/avatar.jpg"
        
        let presenter = ProfilePresenter()
        let view = ViewSpy()
        presenter.view = view
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(view.didCallUpdateProfile, "updateProfile должен быть вызван в viewDidLoad()")
        XCTAssertTrue(view.didCallUpdateAvatar, "updateAvatar должен быть вызван в viewDidLoad()")
    }
    
    func testDidTapLogout_CallsShowLogoutAlert() {
        let presenter = ProfilePresenter()
        let view = ViewSpy()
        presenter.view = view
        
        presenter.didTapLogout()
        
        XCTAssertTrue(view.didCallShowLogoutAlert, "showLogoutAlert должен быть вызван в didTapLogout()")
    }
    
    func testConfirmLogout_ClearsTokenAndResetsToSplash() {
        let presenter = ProfilePresenter()
        let view = ViewSpy()
        presenter.view = view
        
        presenter.confirmLogout()
        
        XCTAssertNil(OAuth2TokenStorage().token, "Токен должен быть очищен в confirmLogout()")
        XCTAssertTrue(view.didCallResetToSplashScreen, "resetToSplashScreen должен быть вызван в confirmLogout()")
    }
}
