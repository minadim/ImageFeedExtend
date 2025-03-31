//
//  ImagesListService.swift
//  ImageFeedExtend
//
//  Created by Nadin on 29.03.2025.
//

import UIKit

// MARK: - Codable структуры для парсинга JSON
struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct PhotoResult: Codable {
    let id: String
    let created_at: String?
    let width: Int
    let height: Int
    let urls: UrlsResult
    let description: String?
    let liked_by_user: Bool?
}

// MARK: - Модель Photo
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

// MARK: - Класс ImagesListService
final class ImagesListService {
    static let shared = ImagesListService()
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isLoading = false
    
    private let apiURL = "https://api.unsplash.com/photos"
    private let accessKey = "5lJ5iQPX1uBMWq_BQefusX8CjRG7s9FdF99IRqMwWpY" // Замените на ваш API ключ

    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        isLoading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let url = URL(string: "\(apiURL)?page=\(nextPage)&per_page=10&client_id=\(accessKey)") else {
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.isLoading = false }
            
            if let error = error {
                print("Ошибка загрузки: \(error.localizedDescription)")
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
                
                let newPhotos = photoResults.map { result in
                    Photo(
                        id: result.id,
                        size: CGSize(width: CGFloat(result.width), height: CGFloat(result.height)),
                        createdAt: result.created_at.flatMap { ISO8601DateFormatter().date(from: $0) },
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.thumb,
                        largeImageURL: result.urls.full,
                        isLiked: result.liked_by_user ?? false
                    )
                }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: .didChangeNotification, object: nil)
                }
            } catch {
                print("Ошибка парсинга JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

// MARK: - Уведомления
extension Notification.Name {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
}
