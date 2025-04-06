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
    
    //private let photosName: [String] = Array(0..<20).map { "\($0)" }
    private let currentDate = Date()
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared //
    private var photos: [Photo] = [] //
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .didChangeNotification, object: nil)
        imagesListService.fetchPhotosNextPage()
    }
    
    @objc private func updateTableView() {
        photos = imagesListService.photos
        tableView.reloadData()
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
            if let imageURL = URL(string: photo.largeImageURL) { // Используй URL большого изображения
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
    
    private  func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let imageURL = URL(string: photo.thumbImageURL) else { return }
                
                URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        cell.configure(with: image, date: self.dateFormatter.string(from: photo.createdAt ?? Date()), isLiked: photo.isLiked)
                    }
                }.resume()
            }
        }
