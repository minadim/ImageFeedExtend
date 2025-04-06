//
//  Untitled.swift
//  ImageFeedExtend
//
//  Created by Nadin on 10.02.2025.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    
    var fullImageUrl: URL?
    
    var imageURL: URL? {
        didSet {
            guard isViewLoaded, let imageURL else { return }
            setImage(with: imageURL)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    private var loaderImageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoaderImageView()
        if let imageURL = imageURL {
            setImage(with: imageURL)
        }
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
        
        loaderImageView.isHidden = false
    }
    
    // MARK: - Image Loading с Kingfisher
    
    private func setImage(with url: URL) {
        UIBlockingProgressHUD.show()
        loaderImageView.isHidden = false
        
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            DispatchQueue.main.async {
                self?.loaderImageView.isHidden = true
            }
            
            guard let self = self else { return }
            
            switch result {
            case .success(let imageResult):
                self.imageView.image = imageResult.image
                self.imageView.contentMode = .scaleAspectFit
                self.imageView.frame = CGRect(origin: .zero, size: imageResult.image.size)
                self.scrollView.contentSize = imageResult.image.size
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError(for: url)
            }
        }
    }
    
    private func showError(for url: URL) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            self.setImage(with: url)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        
        let scale = scrollViewSize.height / imageSize.height
        
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = scale
        
        let scaledSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        imageView.frame = CGRect(origin: .zero, size: scaledSize)
        scrollView.contentSize = scaledSize
        
        let horizontalInset = max((scrollViewSize.width - scaledSize.width) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: 0)
        
        if scaledSize.width > scrollViewSize.width {
            let xOffset = (scaledSize.width - scrollViewSize.width) / 2
            scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
        }
    }
    
    // MARK: - Centering Method
    
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        
        let offsetX = (scrollViewSize.width > imageViewSize.width) ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        let offsetY = (scrollViewSize.height > imageViewSize.height) ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        
        imageView.center = CGPoint(x: scrollView.contentSize.width / 2 + offsetX,
                                   y: scrollView.contentSize.height / 2 + offsetY)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupLoaderImageView() {
        loaderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 83, height: 75))
        
        loaderImageView.image = UIImage(named: "loader")
        loaderImageView.contentMode = .scaleAspectFit
        loaderImageView.center = view.center
        
        view.addSubview(loaderImageView)
    }
}
