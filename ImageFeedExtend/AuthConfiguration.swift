//
//  AuthConfiguration.swift
//  ImageFeedExtend
//
//  Created by Nadin on 19.02.2025.
//

import UIKit

enum Constants {
    static let accessKey = "5lJ5iQPX1uBMWq_BQefusX8CjRG7s9FdF99IRqMwWpY"
    static let secretKey = "PcsbAyyDqOsUs76H4hOiiaoVop6W37511A2_yX1Kp-k"
    static let redirectURI = "imagefeedextend://auth"
    static let accessScope = "public read_user write_user read_photos write_photos write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let profileImageURL = "https://api.unsplash.com/users/%@"
    static let profileURL = "https://api.unsplash.com/me"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
}
