//
//  ProfileViewController.swift
//  ImageFeedExtend
//
//  Created by Nadin on 07.02.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.barTintColor = UIColor(red: 26/255, green: 27/255, blue: 33/255, alpha: 1)
            tabBar.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 33/255, alpha: 1)
        }
        
        exitButton.addTarget(self, action: #selector(exitButtonTap), for: .touchUpInside)
        setupUI()
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        updateAvatar()
    }
    
    // MARK: - Update Profile //
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else {
            print("Ошибка: профиль отсутствует")
            return
        }
        nameLabel.text = profile.name
        usernameLabel.text = profile.loginName
        statusLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        profileImage.kf.setImage(with: url)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 35/255, alpha: 1.0)
        [profileImage, exitButton, nameLabel, usernameLabel, statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    // MARK: - Actions
    
    @objc private func exitButtonTap() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { [weak self] _ in
            self?.logout()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func logout() {
        tokenStorage.token = nil
        
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        
        if let window = view.window {
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

