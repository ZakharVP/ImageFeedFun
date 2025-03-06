//
//  UserResult.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 27.02.2025.
//

struct UserResult: Codable {
    let profileImage: ProfileImage?

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
