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
    private var task: URLSessionDataTask?
    private init() {}
    
    private func makeProfileImageURL() -> URLRequest? {
        
        guard let profile = ProfileService.shared.profile else {
            print("Профиль не получен")
            return nil
        }
        
        let username = profile.username
        print(username)
        
        return URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "Get",
            baseURLString: Constants.defaultBaseUrl)
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<UserResult, NetworkError>) -> Void) {
        
        guard let request = makeProfileImageURL() else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        if task != nil {
            print("task не пустой")
            completion(.failure(NetworkError.httpStatusCode(400)))
            return
        } else {
            print("task пустой")
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, result, error in
            
            guard let self = self else { return }
            
            if let error = error {
                let networkError: NetworkError
                if let urlSessionError = error as? URLError {
                    networkError = NetworkError.urlRequestError(urlSessionError)
                } else {
                    networkError = NetworkError.urlSessionError("Неизвестная ошибка сессии")
                }
                print(networkError)
                completion(.failure(networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("jsonstringImage: \(jsonString)")
            } else {
                print("Error: invalid JSON image")
            }
            do {
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                
                // Извлекаем ссылку на маленькое изображение
                if let smallImageURL = userResult.profileImage?.small {
                    self.profileImageURL = URL(string: smallImageURL)
                    print("Ссылка на аватар загружена: \(smallImageURL)")
                    
                    DispatchQueue.main.async {
                        print("Отправляем уведомление о возможности загрузки аватара")
                        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
                    }
                } else {
                    print("Ссылка на аватар пустая.")
                }
                
                completion(.success(userResult))
            } catch {
                print("Ошибка декодирования: \(error)")
                completion(.failure(NetworkError.httpStatusCode(404)))
            }
        }
        self.task = task
        task.resume()
    }
}
