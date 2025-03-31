//
//  Untitled.swift
//  ImageFeedExtend
//
//  Created by Nadin on 10.02.2025.
//

import UIKit

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: URL? {
        didSet {
                    guard isViewLoaded, let imageURL else { return }
                    loadImage(from: imageURL)
                    if let image = imageView.image {
                        rescaleAndCenterImageInScrollView(image: image)
                    }
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURL = imageURL {
                    loadImage(from: imageURL)
                }
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
    }
    
    // MARK: - Image Loading
        
    private func loadImage(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.contentMode = .center
                    self.imageView.frame = self.scrollView.bounds // размер под scrollView
                    self.rescaleAndCenterImageInScrollView(image: image)
                }
            }
            task.resume()
        }
    
    // MARK: - Private Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        centerImage()
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
}
