//
//  WebViewViewControllerSpy.swift
//  ImageFeedExtend
//
//  Created by Nadin on 13.04.2025.
//
import ImageFeedExtend
import Foundation
    
final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
   
    func load(request: URLRequest) {
        isLoadRequestCalled = true
    }
    
        var isLoadRequestCalled = false
        
        func setProgressValue(_ newValue: Float) {}
        func setProgressHidden(_ isHidden: Bool) {}
        
        var presenter: WebViewPresenterProtocol?
    }
