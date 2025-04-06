//
//  ImagesListService.swift
//  ImageFeedExtend
//
//  Created by Nadin on 29.03.2025.
//

import UIKit

// MARK: - UrlsResult

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

// MARK: - PhotoResult

struct PhotoResult: Decodable {
    let id: String
    let created_at: String?
    let width: Int
    let height: Int
    let urls: UrlsResult
    let description: String?
    let likedByUser: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id, width, height, urls, description
        case created_at = "created_at"
        case likedByUser = "liked_by_user"
    }
}

// MARK: - Модель Photo

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let fullImageUrl: String
    var isLiked: Bool
}

// MARK: - Класс ImagesListService

final class ImagesListService {
    static let shared = ImagesListService()
    
    private(set) var photos: [Photo] = []
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    func resetPhotos() {
        photos = []
    }
    
    private var lastLoadedPage: Int?
    private var isLoading = false
    
    private let apiURL = "https://api.unsplash.com/photos"
    private let accessKey = "5lJ5iQPX1uBMWq_BQefusX8CjRG7s9FdF99IRqMwWpY"
    
    // MARK: - Отправка уведомлений
    
    private func notifyPhotosChanged() {
        NotificationCenter.default.post(name: .didChangeNotification, object: self)
    }
    
    // MARK: - Public Methods
    
    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        isLoading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let url = URL(string: "\(apiURL)?page=\(nextPage)&per_page=10&client_id=\(accessKey)") else {
            isLoading = false
            print("[fetchPhotosNextPage]: [Ошибка URL] Не удалось создать URL с параметрами: page=\(nextPage), per_page=10")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.isLoading = false }
            
            if let error = error {
                print("[fetchPhotosNextPage]: [Ошибка сети] \(error.localizedDescription) для запроса: \(url.absoluteString)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Ошибка HTTP: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let photoResults = try decoder.decode([PhotoResult].self, from: data)
                
                let dateFormatter = ISO8601DateFormatter()
                
                let newPhotos = photoResults.compactMap { result -> Photo? in
                    
                    guard let createdAt = result.created_at.flatMap({ dateFormatter.date(from: $0) }) else { return nil }
                    
                    return Photo(
                        id: result.id,
                        size: CGSize(width: CGFloat(result.width), height: CGFloat(result.height)),
                        createdAt: createdAt,
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.thumb,
                        largeImageURL: result.urls.full,
                        fullImageUrl: result.urls.full,
                        isLiked: result.likedByUser ?? false
                    )
                }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    self.notifyPhotosChanged()
                }
                
            } catch {
                print("Ошибка парсинга JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            print("Invalid URL: https://api.unsplash.com/photos/\(photoId)/like")
            
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        guard let accessToken = OAuth2TokenStorage().token else {
            completion(.failure(NSError(domain: "Missing Token", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTP Error", code: 0, userInfo: nil)))
                return
            }
            
            DispatchQueue.main.async {
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        fullImageUrl: photo.fullImageUrl,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                    self.notifyPhotosChanged()
                }
                
                completion(.success(()))
            }
        }
        
        task.resume()
    }
}

// MARK: - Уведомления

extension Notification.Name {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
}
