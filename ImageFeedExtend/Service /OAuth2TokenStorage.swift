//
//  OAuth2TokenStorage.swift
//  ImageFeedExtend
//
//  Created by Nadin on 27.02.2025.
//

import Foundation
import Security
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let key = "OAuthToken"    
    
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get { KeychainWrapper.standard.string(forKey: key) }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: key)
            } else {
                KeychainWrapper.standard.removeObject(forKey: key)
            }
        }
    }
    
    func reset() {
        token = nil
    }
    
    init() {}
}
