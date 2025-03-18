//
//  ProfileResult.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 27.10.2024.
//

struct PhotoResult: Codable {
    
    let id: String
    let createdAt: String
    let updateAt: String?
    let width: Int?
    let height: Int?
    let color: String?
    let blurHash: String?
    let likes: Int?
    let likedByUser: Bool?
    let description: String?
    let user: Profile?
    let urls: UrlsResult?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updateAt = "updated_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description
        case user
        case urls
    }
    
}
