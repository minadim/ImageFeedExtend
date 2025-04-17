//
//  ImagesListPresenter.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

import Foundation
import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    private(set) var photos: [Photo] = []
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangePhotos(_:)),
            name: .didChangeNotification,
            object: nil
        )
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func didTapLike(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        view?.showLoading()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.view?.hideLoading()
                
                switch result {
                case .success:
                    self.photos[indexPath.row].isLiked.toggle()
                    self.view?.reloadRows(at: [indexPath])
                case .failure(let error):
                    print("Ошибка при изменении лайка: \(error)")
                }
            }
        }
    }
    
    private var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("UITestMode")
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        guard !isUITesting else { return }
        
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    @objc private func didChangePhotos(_ notification: Notification) {
        let oldCount = photos.count
        let newPhotos = imagesListService.photos
        let newCount = newPhotos.count
        
        guard newCount > oldCount else { return }
        
        photos = newPhotos
        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        DispatchQueue.main.async {
            self.view?.insertRows(at: indexPaths)
        }
    }
}
