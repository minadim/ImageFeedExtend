//
//  WebViewPresenterSpy.swift
//  ImageFeedExtend
//
//  Created by Nadin on 13.04.2025.
//

import ImageFeedExtend
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    private(set) var viewDidLoadCalled: Bool = false
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
