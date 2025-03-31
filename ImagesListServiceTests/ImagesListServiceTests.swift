//
//  ImageFeedExtendTests.swift
//  ImageFeedExtendTests
//
//  Created by Nadin on 31.03.2025.
//

import XCTest  // ✅ правильный импорт

@testable import ImageFeedExtend
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
           let service = ImagesListService()
           
           let expectation = self.expectation(description: "Wait for Notification")
           NotificationCenter.default.addObserver(
               forName: ImagesListService.didChangeNotification,
               object: nil,
               queue: .main) { _ in
                   expectation.fulfill()
               }
           
           service.fetchPhotosNextPage()
           wait(for: [expectation], timeout: 10)
           
           XCTAssertEqual(service.photos.count, 10)
       }
   }
