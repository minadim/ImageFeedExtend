//
//  ViewController.swift
//  ImageFeedExtend
//
//  Created by Nadin on 27.01.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties
    
    private let currentDate = Date()
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    private var isFetchingPhotos = false

    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewAnimated), name: .didChangeNotification, object: nil)
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: - Обновление таблицы с анимацией
    
    @objc private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newPhotos = imagesListService.photos
        let newCount = newPhotos.count
        
        guard oldCount != newCount else { return }
        
        photos = newPhotos
        
        var indexPaths: [IndexPath] = []
        for index in oldCount..<newCount {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    // MARK: - Prepare Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == showSingleImageSegueIdentifier,
            let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
        else {
            assertionFailure("Invalid segue destination")
            return
        }
        
        let photo = photos[indexPath.row]
        if let imageURL = URL(string: photo.fullImageUrl) {
            viewController.imageURL = imageURL
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageViewWidth = tableView.frame.width - 24
        let scaleFactor = imageViewWidth / photo.size.width
        let imageViewHeight = photo.size.height * scaleFactor
        return imageViewHeight + 16
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            isFetchingPhotos = true
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.selectionStyle = .none
        return imageListCell
    }
    
    // MARK: - Configuration
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let imageURL = URL(string: photo.thumbImageURL) else {
            print(" Ошибка: некорректный URL для фото с ID \(photo.id)")
            return
        }
        
        let placeholder = UIImage(named: "placeholder")
        
        cell.delegate = self
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success(let value):
                cell.configure(with: value.image,
                               date: self.dateFormatter.string(from: photo.createdAt ?? Date()),
                               isLiked: photo.isLiked)
                
            case .failure:
                
                let formattedDate = photo.createdAt.map { self.dateFormatter.string(from: $0) } ?? "—"
                cell.configure(
                    with: placeholder,
                    date: formattedDate,
                    isLiked: photo.isLiked
                )
                
            }
        }
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success:
                    self.photos[indexPath.row].isLiked.toggle()
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                case .failure(let error):
                    print("Ошибка при изменении лайка: \(error)")
                    // TODO: Показать ошибку с использованием UIAlertController
                }
            }
        }
    }
}



