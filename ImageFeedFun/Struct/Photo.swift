//
//  Photo.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 08.03.2025.
//

import Foundation

struct Photo: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs
    let links: PhotoLinks
    let likes: Int
    var likedByUser: Bool
    let user: ProfileResult

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case altDescription = "alt_description"
        case urls
        case links
        case likes
        case likedByUser = "liked_by_user"
        case user
    }
}
