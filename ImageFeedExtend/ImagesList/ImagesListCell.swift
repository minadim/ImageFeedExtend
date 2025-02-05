//
//  ImagesList.swift
//  ImageFeedExtend
//
//  Created by Nadin on 28.01.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    
    private var isLiked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        applyGradient()
    }
    private func setupUI() {
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        cellImage.contentMode = .scaleAspectFill
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.frame.size = CGSize(width: 44, height: 44)
    }
    func configure(with image: UIImage?, date: String, isLiked: Bool) {
        cellImage.image = image
        dataLabel.text = date
        self.isLiked = false
        updateLikeButton()
    }
    private func updateLikeButton() {
        let likeImage = isLiked ? UIImage(named: "like_button") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    @IBAction func likeButtonTap(_ sender: UIButton) {
        isLiked.toggle()
        updateLikeButton()
    }
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.clear.cgColor]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    private func applyGradient() {
        gradientLayer.frame = dataLabel.bounds.insetBy(dx: -5, dy: 0)
        dataLabel.layer.insertSublayer(gradientLayer, at: 0)
    }
}
