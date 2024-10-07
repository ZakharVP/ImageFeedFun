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
  
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
    
    private enum ParseError: Error {
        case createdAtFailure
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        scope = try container.decode(String.self, forKey: .scope)
        createdAt = try container.decode(Int.self, forKey: .createdAt)
    }
}
