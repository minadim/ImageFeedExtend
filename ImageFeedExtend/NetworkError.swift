//
//  NetworkError.swift
//  ImageFeedExtend
//
//  Created by Nadin on 20.03.2025.
//

import Foundation

enum NetworkError: Error {
    case urlSessionError
    case urlRequestError(Error)
    case invalidResponse
    case httpStatusCode(Int)
    case noData
    case decodingError(Error) 
    case unknown
}
