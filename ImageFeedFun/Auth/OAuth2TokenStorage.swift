//
//  OAuth2TokenStorage.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 05.10.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    //private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token
    }
    
   // var token: String? {
    func get() -> String? {
            //storage.string(forKey: Keys.token.rawValue)
            let tokenString = KeychainWrapper.standard.string(forKey: "Auth token")
            return tokenString
        }
    func set(newValue: String) {
            //storage.set(newValue, forKey: Keys.token.rawValue)
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: "Auth token")
        }
   // }
    
    
}
