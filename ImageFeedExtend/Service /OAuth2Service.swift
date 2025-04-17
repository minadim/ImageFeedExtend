//
//  OAuth2Service.swift
//  ImageFeedExtend
//
//  Created by Nadin on 27.02.2025.
//

import Foundation
import Network

// MARK: - OAuth2Service

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

final class OAuth2Service {
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - Singleton
    
    static let shared = OAuth2Service()
    private init() {}
    
    private var accessToken: String?
    
    private var currentCode: String?
    private var completions: [(Result<String, Error>) -> Void] = []
    private var currentTask: URLSessionDataTask?
    
    // MARK: - Private Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            print("[OAuth2Service]: URL Error - Invalid URL")
            return nil }
        
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
            print("[OAuth2Service]: JSONSerialization Error - \(error.localizedDescription)")
            return nil
        }
        
        return request
    }
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void)
    {
        DispatchQueue.main.async {
            if let currentCode = self.currentCode, currentCode == code {
                self.completions.append(completion)
                return
            }
            
            self.currentTask?.cancel()
            self.currentCode = code
            self.completions = [completion]
            
            guard let request = self.makeOAuthTokenRequest(code: code) else {
                print("[OAuth2Service]: Request Error - Unable to create request")
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            self.currentTask = URLSession.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
                DispatchQueue.main.async {
                    let finalResult: Result<String, Error>
                    switch result {
                    case .success(let responseBody):
                        self.tokenStorage.token = responseBody.accessToken
                        UserDefaults.standard.synchronize()
                        finalResult = .success(responseBody.accessToken)
                    case .failure(let error):
                        finalResult = .failure(error)
                    }
                    self.completions.forEach { $0(finalResult) }
                    self.completions.removeAll()
                    self.currentTask = nil
                    self.currentCode = nil
                }
            }
            
            self.currentTask?.resume()
        }
    }
}

private extension URLSession {
    
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        
        let task = dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    print("[objectTask]: NetworkError - \(error.localizedDescription)")
                    completion(.failure(NetworkError.urlRequestError(error)))
                    
                } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    print("[objectTask]: HTTP Status Code Error - \(response.statusCode)")
                    completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    
                } else if let data = data {
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        print("[objectTask]: Decoding Error - \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                        completion(.failure(NetworkError.decodingError(error)))
                    }
                } else {
                    print("[objectTask]: URLSession Error - No data received")
                    completion(.failure(NetworkError.urlSessionError))
                }
            }
        }
        
        return task
    }
}
