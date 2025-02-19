//
//  ProfileImageService.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 16.02.2025.
//
import UIKit
import Kingfisher

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    //let avatarImage: UIImage?
    private var task: URLSessionDataTask?
    private var isControllerReady = false
    private init() {}
    
    let semaphore = DispatchSemaphore(value: 0)
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    var avatarImage: UIImage?
  
    @MainActor
    func fetchProfileImageURL(from avatarURL: String, completion: @escaping () -> Void) {
        
        assert(Thread.isMainThread)
        guard let url = URL(string: avatarURL) else { return }
        
        let imageView = UIImageView()
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                self.avatarImage = value.image
                print("Установили картинку в переменную")
                completion()
      
                print("Отправили уведомление")
                if self.isControllerReady {
                    NotificationCenter.default
                        .post(
                        name: ProfileImageService.didChangeNotification,
                        object: nil,
                        userInfo: ["URL": url]
                    )
                }
  
            case .failure(let error):
                print("Ошибка загрузки: \(error)")
            }
        }
    }
    
    func setControllerReady() {
        isControllerReady = true
    }
}
