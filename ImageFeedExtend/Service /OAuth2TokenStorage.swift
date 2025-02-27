//
//  OAuth2TokenStorage.swift
//  ImageFeedExtend
//
//  Created by Nadin on 27.02.2025.
//

import Foundation

final class OAuth2TokenStorage {
    private let key = "OAuthToken"
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: key) }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
}
