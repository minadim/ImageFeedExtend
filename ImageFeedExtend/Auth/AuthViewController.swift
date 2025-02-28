//
//  AuthViewController.swift
//  ImageFeedExtend
//
//  Created by Nadin on 19.02.2025.
//

import UIKit


final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let authService = OAuth2Service.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    // MARK: - Private Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "logo_backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "logo_backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webViewVC = segue.destination as? WebViewViewController {
            webViewVC.delegate = self
        }
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        authService.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.tokenStorage.token = token
                    self.delegate?.didAuthenticate(self)
                case .failure(let error):  
                    print("Ошибка получения токена: \(error.localizedDescription)")
                }
            }
        }
    }
}

