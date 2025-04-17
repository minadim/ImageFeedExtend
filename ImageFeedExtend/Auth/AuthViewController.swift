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
    private let profileService = ProfileService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let authHelper = AuthHelper()
        print(authHelper.authURL()?.absoluteString ?? "URL is nil")
        configureBackButton()
    }
    
    // MARK: - Private Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "logo_backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "logo_backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
    
    private func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Что-то пошло не так",
                                          message: "Не удалось войти в систему",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        authService.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                
                UIBlockingProgressHUD.dismiss()
                print("fetchOAuthToken завершён")
                switch result {
                case .success(let token):
                    self.tokenStorage.token = token
                    self.fetchUserProfile(token: token)
                case .failure(let error):
                    print("Ошибка авторизации произошла: \(error.localizedDescription)")
                    self.showAlert()
                }
            }
        }
    }
    
    private func fetchUserProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    self.delegate?.didAuthenticate(self)
                case .failure:
                    print("Ошибка загрузки профиля")
                    self.showAlert()
                }
            }
        }
    }
}
