//
//  ImagesListViewControllerSpy.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

import Foundation
@testable import ImageFeedExtend

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    private(set) var reloadCalledIndexPaths: [IndexPath] = []
    private(set) var insertCalledIndexPaths: [IndexPath] = []
    private(set) var showLoadingCalled = false
    private(set) var hideLoadingCalled = false
    
    var performedSegueIdentifier: String?

        func performSegue(withIdentifier identifier: String, sender: Any?) {
            performedSegueIdentifier = identifier
        }
    func reloadRows(at indexPaths: [IndexPath]) {
        reloadCalledIndexPaths = indexPaths
    }

    func insertRows(at indexPaths: [IndexPath]) {
        insertCalledIndexPaths = indexPaths
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }
}
