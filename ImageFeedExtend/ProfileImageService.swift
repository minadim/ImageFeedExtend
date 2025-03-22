//
//  ProfileImageService.swift
//  ImageFeedExtend
//
//  Created by Nadin on 17.03.2025.
//

import Foundation

final class ProfileImageService {
    
    // MARK: - Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private init() {}
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    // MARK: - Models
    
    private struct UserResult: Decodable {
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    private struct ProfileImage: Decodable {
        let small: String
    }
    
    // MARK: - Methods
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let token = OAuth2TokenStorage().token else {
            print("[ProfileImageService]: Ошибка - отсутствует токен авторизации")
            completion(.failure(NetworkError.unknown))
            return
        }
        
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("[ProfileImageService]: Ошибка - некорректный URL")
            completion(.failure(NetworkError.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.small
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": userResult.profileImage.small]
                )
                completion(.success(userResult.profileImage.small))
            case .failure(let error):
                print("[ProfileImageService]: Ошибка загрузки изображения профиля - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    private func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("[objectTask]: Ошибка сетевого запроса - \(error.localizedDescription)")
                    completion(.failure(NetworkError.urlRequestError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("[objectTask]: Ошибка - некорректный HTTP-ответ")
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("[objectTask]: HTTP ошибка - код \(httpResponse.statusCode)")
                    completion(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    print("[objectTask]: Ошибка - нет данных в ответе")
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch let decodingError {
                    print("[objectTask]: Ошибка декодирования - \(decodingError.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(NetworkError.decodingError(decodingError)))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

