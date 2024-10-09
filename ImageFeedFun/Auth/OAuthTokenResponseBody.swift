//
//  OAuthTokenResponseBody.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 07.10.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
  
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    private enum ParseError: Error {
        case createdAtFailure
    }
    
}
