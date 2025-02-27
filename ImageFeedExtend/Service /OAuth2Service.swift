//
//  OAuth2Service.swift
//  ImageFeedExtend
//
//  Created by Nadin on 27.02.2025.
//

import Foundation

// MARK: - OAuth2Service

struct OAuthTokenResponseBody: Codable {
    let access_token: String
}

final class OAuth2Service {
    
    // MARK: - Singleton
    
    static let shared = OAuth2Service()
    private init() {}
    
    // MARK: - Private Methods
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyParams: [String: String] = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
        } catch {
            print("Ошибка сериализации JSON: \(error.localizedDescription)")
            return nil
        }
        return request
    }
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode),
                      let data = data else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                    return
                }
                
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(responseBody.access_token))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

