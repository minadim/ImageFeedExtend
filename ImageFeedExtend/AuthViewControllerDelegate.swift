//
//  AuthViewControllerDelegate.swift
//  ImageFeedExtend
//
//  Created by Nadin on 27.02.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
