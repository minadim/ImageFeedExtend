//
//  UIBlockingProgressHUD.swift
//  ImageFeedExtend
//
//  Created by Nadin on 16.03.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    // MARK: - Private Properties
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    private(set) static var isVisible = false
    
    // MARK: - Public Methods
    
    static func show() {
        guard !isVisible else { return }
        isVisible = true
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        guard isVisible else { return }
        isVisible = false
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
