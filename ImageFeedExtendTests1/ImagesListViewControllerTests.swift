//
//  ImagesListViewControllerTests.swift
//  ImageFeedExtend
//
//  Created by Nadin on 15.04.2025.
//

import XCTest
@testable import ImageFeedExtend

final class ImagesListViewControllerTests: XCTestCase {
    
    func test_reloadRows_setsCorrectIndexPaths() {
        // arrange
        let viewController = ImagesListViewControllerSpy()
        let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]
        
        // act
        viewController.reloadRows(at: indexPaths)
        
        // assert
        XCTAssertEqual(viewController.reloadCalledIndexPaths, indexPaths, "Ожидалось, что reloadRows вызовет правильные indexPaths")
    }
    
    func test_insertRows_setsCorrectIndexPaths() {
        // arrange
        let viewController = ImagesListViewControllerSpy()
        let indexPaths = [IndexPath(row: 3, section: 0)]
        
        // act
        viewController.insertRows(at: indexPaths)
        
        // assert
        XCTAssertEqual(viewController.insertCalledIndexPaths, indexPaths, "Ожидалось, что insertRows вызовет правильные indexPaths")
    }
    
    func test_showLoading_setsFlagTrue() {
        let viewController = ImagesListViewControllerSpy()
        viewController.showLoading()
        XCTAssertTrue(viewController.showLoadingCalled, "showLoading должен установить флаг в true")
    }
    
    func test_hideLoading_setsFlagTrue() {
        let viewController = ImagesListViewControllerSpy()
        viewController.hideLoading()
        XCTAssertTrue(viewController.hideLoadingCalled, "hideLoading должен установить флаг в true")
    }
    
    func test_performSegue_setsCorrectIdentifier() {
        let viewController = ImagesListViewControllerSpy()
        viewController.performSegue(withIdentifier: "ShowSingleImage", sender: nil)
        XCTAssertEqual(viewController.performedSegueIdentifier, "ShowSingleImage", "performSegue должен установить правильный identifier")
    }
    func test_viewDidLoad_callsViewDidLoad() {
        // arrange
        let presenter = ImagesListPresenterSpy()
        
        // act
        presenter.viewDidLoad()
        
        // assert
        XCTAssertTrue(presenter.viewDidLoadCalled, "Ожидалось, что viewDidLoad будет вызван")
    }
    
    func test_didTapLike_setsCorrectIndexPath() {
        // arrange
        let presenter = ImagesListPresenterSpy()
        let testIndexPath = IndexPath(row: 1, section: 0)
        
        // act
        presenter.didTapLike(at: testIndexPath)
        
        // assert
        XCTAssertEqual(presenter.didTapLikeCalledIndexPath, testIndexPath, "Ожидалось, что будет передан корректный indexPath в didTapLike")
    }
    
    func test_willDisplayCell_setsCorrectIndexPath() {
        // arrange
        let presenter = ImagesListPresenterSpy()
        let testIndexPath = IndexPath(row: 2, section: 0)
        
        // act
        presenter.willDisplayCell(at: testIndexPath)
        
        // assert
        XCTAssertEqual(presenter.willDisplayCellIndexPath, testIndexPath, "Ожидалось, что будет передан корректный indexPath в willDisplayCell")
    }
}




