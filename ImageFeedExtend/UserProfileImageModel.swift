//
//  UserProfileImageModel.swift
//  ImageFeedExtend
//
//  Created by Nadin on 23.03.2025.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String
}
