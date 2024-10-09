//
//  OAuth2TokenStorage.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 05.10.2024.
//

import Foundation

final class OAuth2TokenStorage {
    
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
