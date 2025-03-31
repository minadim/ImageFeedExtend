//
//  Constants.swift
//  ImageFeedExtend
//
//  Created by Nadin on 19.02.2025.
//

import UIKit

enum Constants {
    static let accessKey = "5lJ5iQPX1uBMWq_BQefusX8CjRG7s9FdF99IRqMwWpY"
    static let secretKey = "PcsbAyyDqOsUs76H4hOiiaoVop6W37511A2_yX1Kp-k"
    static let redirectURI = "imagefeedextend://auth"
    static let accessScope = "public read_user write_user read_photos write_photos"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let profileImageURL = "https://api.unsplash.com/users/%@"
    static let profileURL = "https://api.unsplash.com/me"
}

