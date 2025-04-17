//
//  Untitled.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

@testable import ImageFeedExtend
import Foundation

final class PresenterSpy: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?

    private(set) var viewDidLoadCalled = false
    private(set) var didTapLogoutCalled = false
    private(set) var confirmLogoutCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapLogout() {
        didTapLogoutCalled = true
    }

    func confirmLogout() {
        confirmLogoutCalled = true
    }
}

