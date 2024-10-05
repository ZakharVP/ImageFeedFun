//
//  WebViewViewControllerDelegate.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 25.09.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)

}
