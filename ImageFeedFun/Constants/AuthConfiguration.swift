//
//  Constants.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 16.09.2024.
//

import Foundation

enum Constants {
    static let accessKey = "sikWw7xxG7S8WLOAGegqjdUiCLYkL0rRX2dapDJLxjI"
    static let secretKey = "wksNGheQsV0g-60EEzVDiRppu6OOnrlCEV141osioI0"
    static let redirectURL = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUrl = URL(string: "https://api.unsplash.com")!
    static let unsplashGetTokenURLString = "https://unsplash.com/oauth/token"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
        self.defaultBaseURL = defaultBaseURL
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURL,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString,
            defaultBaseURL: Constants.defaultBaseUrl
        )
    }
}
