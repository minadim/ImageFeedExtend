//
//  ImagesListPresenterSpy.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

import Foundation
import UIKit
@testable import ImageFeedExtend

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    private(set) var viewDidLoadCalled = false
    private(set) var didTapLikeCalledIndexPath: IndexPath?
    private(set) var willDisplayCellIndexPath: IndexPath?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapLike(at indexPath: IndexPath) {
        didTapLikeCalledIndexPath = indexPath
    }

    func willDisplayCell(at indexPath: IndexPath) {
        willDisplayCellIndexPath = indexPath
    }
}
