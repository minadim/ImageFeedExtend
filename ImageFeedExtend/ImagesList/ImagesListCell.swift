//
//  ImagesList.swift
//  ImageFeedExtend
//
//  Created by Nadin on 28.01.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - @IBOutlet properties
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dataLabel: UILabel!
    
    // MARK: - Private properties
    private var isLiked: Bool = false
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.clear.cgColor]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    // MARK: - Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        applyGradient()
    }
    
    // MARK: - Internal methods
    func configure(with image: UIImage?, date: String, isLiked: Bool) {
        cellImage.image = image
        dataLabel.text = date
        self.isLiked = isLiked
        updateLikeButton()
    }
    
    // MARK: - @IBAction methods
    @IBAction private func likeButtonTap(_ sender: UIButton) {
        isLiked.toggle()
        updateLikeButton()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        cellImage.contentMode = .scaleAspectFill
        
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.frame.size = CGSize(width: 44, height: 44)
    }
    
    private func updateLikeButton() {
        let likeImage = isLiked ? UIImage(named: "like_button") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    private func applyGradient() {
        gradientLayer.frame = dataLabel.bounds.insetBy(dx: -5, dy: 0)
        dataLabel.layer.insertSublayer(gradientLayer, at: 0)
    }
}
