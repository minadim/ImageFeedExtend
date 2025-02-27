//
//  WebViewViewControllerDelegate.swift
//  ImageFeedExtend
//
//  Created by Nadin on 23.02.2025.
//

import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
