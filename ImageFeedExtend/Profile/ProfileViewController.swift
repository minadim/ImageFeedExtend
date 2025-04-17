//
//  ProfileViewController.swift
//  ImageFeedExtend
//
//  Created by Nadin on 07.02.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var presenter: ProfilePresenterProtocol?
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Profil")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Exit"), for: .normal)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            configure(ProfilePresenter())
        }
        
        presenter?.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 35/255, alpha: 1.0)
        
        [profileImage, exitButton, nameLabel, usernameLabel, statusLabel].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            statusLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8)
        ])
        
        exitButton.addTarget(self, action: #selector(exitButtonTap), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func exitButtonTap() {
        presenter?.didTapLogout()
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func updateProfile(name: String, username: String, bio: String) {
        nameLabel.text = name
        usernameLabel.text = username
        statusLabel.text = bio
    }
    
    func updateAvatar(url: URL) {
        profileImage.kf.setImage(with: url)
    }
    
    func showLogoutAlert() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { [weak self] _ in
            self?.presenter?.confirmLogout()
        }))
        present(alertController, animated: true)
    }
    
    func resetToSplashScreen() {
        if let window = view.window {
            let splashVC = SplashViewController()
            window.rootViewController = splashVC
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
