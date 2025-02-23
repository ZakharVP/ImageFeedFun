//
//  ProfileResult.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 27.10.2024.
//

struct ProfileResult: Codable {
    
    let userLogin: String
    let firstName: String
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case userLogin = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage = "profile_image"
    }
}
