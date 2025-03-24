//
//  WebViewPresenterSpy.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 20.03.2025.
//

//import ImageFeedFun
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
