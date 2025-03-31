//
//  ProfileService.swift
//  ImageFeedExtend
//
//  Created by Nadin on 16.03.2025.
//

import Foundation

final class ProfileService {
    
    // MARK: - Private Properties
    
    private var task: URLSessionTask?
    private let session = URLSession.shared
    private var lastToken: String?
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    // MARK: - Public Methods
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if task != nil {
            if lastToken != token {
                task?.cancel()
                task = nil
            } else {
                return
            }
        }
        lastToken = token
        
        guard let url = URL(string: Constants.profileURL) else {
            print("[ProfileService]: URLError - Invalid URL")
            completion(.failure(NSError(domain: "ProfileService", code: -2, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                defer { self.task = nil }
                
                if let error = error as NSError? {
                    if error.code == NSURLErrorCancelled {
                        return
                    }
                    print("[ProfileService]: NetworkError - \(error.localizedDescription), URL: \(request.url?.absoluteString ?? "Unknown")")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("[ProfileService]: DataError - No data received, URL: \(request.url?.absoluteString ?? "Unknown")")
                    completion(.failure(NSError(domain: "ProfileService", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let profile = Profile(profileResult: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                } catch {
                    print("[ProfileService]: DecodingError - \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}

// MARK: - ProfileResult

struct ProfileResult: Decodable {
    let username: String
    let first_name: String?
    let last_name: String?
    let bio: String?
}

// MARK: - Profile

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = [profileResult.first_name, profileResult.last_name]
            .compactMap { $0 }
            .joined(separator: " ")
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

