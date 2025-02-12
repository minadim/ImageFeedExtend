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
    
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    private let currentDate = Date()
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
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
    }
    
    // MARK: - Prepare Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            _ = viewController.view
            viewController.imageView.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageViewWidth = tableView.frame.width - 24
        let scaleFactor = imageViewWidth / image.size.width
        let imageViewHeight = image.size.height * scaleFactor
        return imageViewHeight + 16
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
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
        let imageName = photosName[indexPath.row]
        
        guard let image = UIImage(named: imageName) else {
            return
        }
        
        let isLiked = indexPath.row % 2 == 0
        cell.configure(with: image, date: dateFormatter.string(from: currentDate), isLiked: isLiked)
    }
}
