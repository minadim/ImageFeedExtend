//
//  ImageFeedExtendTests1.swift
//  ImageFeedExtendTests1
//
//  Created by Nadin on 13.04.2025.
//

import Testing
import WebKit

@testable import ImageFeedExtend
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let vc = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        vc.setValue(WKWebView(), forKey: "webView")
        vc.setValue(UIProgressView(), forKey: "progressView")
        
        vc.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewControllerSpy = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        presenter.view = viewControllerSpy
        viewControllerSpy.presenter = presenter
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewControllerSpy.isLoadRequestCalled, "Метод loadRequest должен быть вызван после viewDidLoad()")
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        
        // when
        let shouldHide = presenter.shouldHideProgress(for: 1.0)
        
        // then
        XCTAssertTrue(shouldHide, "Прогресс должен скрываться при значении 1.0")
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        // when
        guard let url = authHelper.authURL(),
              let urlString = url.absoluteString.removingPercentEncoding else {
            XCTFail("URL is nil")
            return
        }
        // then
        XCTAssertTrue(urlString.contains(configuration.authURLString), "Missing base URL")
        XCTAssertTrue(urlString.contains(configuration.accessKey), "Missing access key")
        XCTAssertTrue(urlString.contains(configuration.redirectURI), "Missing redirect URI")
        XCTAssertTrue(urlString.contains("code"), "Missing response type")
        XCTAssertTrue(urlString.contains(configuration.accessScope), "Missing scope")
    }
    
    func testCodeFromURL() {
        // given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        
        let authHelper = AuthHelper()
        
        // when
        guard let url = urlComponents?.url else {
            XCTFail("URL is nil")
            return
        }
        let code = authHelper.code(from: url)
        
        // then
        XCTAssertEqual(code, "test code", "Метод должен извлекать код из URL")
    }
}







