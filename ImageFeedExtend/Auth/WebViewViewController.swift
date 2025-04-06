//
//  WebViewViewController.swift
//  ImageFeedExtend
//
//  Created by Nadin on 19.02.2025.
//

import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Properties
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - IBActions
    
    @IBAction private func backButtonTap(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
        webView.navigationDelegate = self
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 self?.updateProgress()
             })
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("Ошибка: не удалось создать URLComponents")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url else {
            print("Ошибка: не удалось получить URL из URLComponents")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let code = code(from: navigationAction) else {
            decisionHandler(.allow)
            return
        }
        UIBlockingProgressHUD.show()
        delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        decisionHandler(.cancel)
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url else {
            print("Ошибка: URL отсутствует")
            return nil
        }
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("Ошибка разбора URL")
            return nil
        }
        for item in urlComponents.queryItems ?? [] {
            print("Найден параметр: \(item.name) = \(item.value ?? "nil")")
        }
        guard let codeItem = urlComponents.queryItems?.first(where: { $0.name == "code" }) else {
            print("Код авторизации не найден в URL")
            return nil
        }
        print("Код авторизации успешно извлечён: \(codeItem.value ?? "nil")")
        return codeItem.value
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    // MARK: - Constants
    
    private enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
}
