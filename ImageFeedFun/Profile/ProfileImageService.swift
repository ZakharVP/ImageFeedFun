//
//  ProfileImageService.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 16.02.2025.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    private(set) var profileImageURL: URL?
  
    func fetchProfileImageURL(from avatarURL: String) {
        
        guard let url = URL(string: avatarURL) else { return }
        self.profileImageURL = url
        print("Ссылка на профиль картинки загружена")
        print(url)
        
        DispatchQueue.main.async {
               NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
        }
    }
}
