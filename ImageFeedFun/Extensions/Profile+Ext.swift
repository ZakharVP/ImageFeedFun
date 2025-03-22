//
//  ProfileResult.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 27.10.2024.
//

extension Profile {
    init(result profile: ProfileResult) {
        self.init(
            username:   profile.userLogin,
            name:       "\(profile.firstName ?? "") \(profile.lastName ?? "")",
            loginName:  "@\(profile.userLogin)",
            bio:        profile.bio
        )
    }
}

extension ProfileService: ProfileServiceProtocol {}
extension ProfileLogoutService: ProfileLogoutServiceProtocol {}
extension OAuth2TokenStorage: OAuth2TokenStorageProtocol {}
