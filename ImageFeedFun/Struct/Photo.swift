//
//  Photo.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 08.03.2025.
//

import Foundation

struct Photo: Codable {
    let id: String
    let size: CGSize?
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case size
        case createdAt
        case welcomeDescription = "welcome_description"
        case thumbImageURL = "thumb_url"
        case largeImageURL = "large_url"
        case isLiked = "is_liked"
    }
}
