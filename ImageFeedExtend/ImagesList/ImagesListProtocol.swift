//
//  ImagesListProtocol.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

import Foundation
import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }

    func viewDidLoad()
    func didTapLike(at indexPath: IndexPath)
    func willDisplayCell(at indexPath: IndexPath)
}

protocol ImagesListViewControllerProtocol: AnyObject {
    func reloadRows(at indexPaths: [IndexPath])
    func insertRows(at indexPaths: [IndexPath])
    func showLoading()
    func hideLoading()
}
