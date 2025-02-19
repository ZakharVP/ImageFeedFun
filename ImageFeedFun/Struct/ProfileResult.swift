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

//{"id":"T__ZswH9h2w",
//    "updated_at":"2025-02-16T16:00:56Z",
//    "username":"trit5",
//    "name":"Захар Панченко",
//    "first_name":"Захар",
//    "last_name":"Панченко",
//    "twitter_username":null,
//    "portfolio_url":null,
//    "bio":null,"location":null,
//    "links":{"self":"https://api.unsplash.com/users/trit5","html":"https://unsplash.com/@trit5","photos":"https://api.unsplash.com/users/trit5/photos","likes":"https://api.unsplash.com/users/trit5/likes","portfolio":"https://api.unsplash.com/users/trit5/portfolio","following":"https://api.unsplash.com/users/trit5/following","followers":"https://api.unsplash.com/users/trit5/followers"},
//"profile_image":{
//"small":"https://images.unsplash.com/profile-1739721653721-5350be4438d3image?ixlib=rb-4.0.3\u0026crop=faces\u0026fit=crop\u0026w=32\u0026h=32",
//"medium":"https://images.unsplash.com/profile-1739721653721-5350be4438d3image?ixlib=rb-4.0.3\u0026crop=faces\u0026fit=crop\u0026w=64\u0026h=64",
//"large":"https://images.unsplash.com/profile-1739721653721-5350be4438d3image?ixlib=rb-4.0.3\u0026crop=faces\u0026fit=crop\u0026w=128\u0026h=128"
//},
//"instagram_username":null,"total_collections":0,"total_likes":0,"total_photos":0,"total_promoted_photos":0,"total_illustrations":0,"total_promoted_illustrations":0,"accepted_tos":false,"for_hire":false,"social":{"instagram_username":null,"portfolio_url":null,"twitter_username":null,"paypal_email":null},
//    "followed_by_user":false,
//    "photos":[],
//    "badge":null,
//    "tags":{"custom":[],"aggregated":[]},
//    "followers_count":0,"following_count":0,"allow_messages":true,"numeric_id":17300574,"downloads":0,
//    "meta":{"index":false},
//    "uid":"T__ZswH9h2w",
//    "confirmed":true,
//    "uploads_remaining":10,
//    "unlimited_uploads":false,
//    "email":"zakhar-panchenko@yandex.ru",
//    "dmca_verification":"unverified",
//    "unread_in_app_notifications":false,
//    "unread_highlight_notifications":false
//}
