//
//  OAuth2TokenStorage.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 05.10.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    func get() -> String? {
            let tokenString = KeychainWrapper.standard.string(forKey: "Auth token")
            return tokenString
        }
    func set(newValue: String) {
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: "Auth token")
        }
    
    func removeToken(forKey key: String) -> Bool {
           return KeychainWrapper.standard.removeObject(forKey: key)
       }
}
