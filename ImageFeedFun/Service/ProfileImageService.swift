//
//  ProfileImageService.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 16.02.2025.
//

import Foundation

final class ProfileImageService {

    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(
        "ProfileImageProviderDidChange")
    private(set) var profileImageURL: URL?
    private var task: URLSessionDataTask?
    private init() {}

    private func makeProfileImageURL() -> URLRequest? {

        guard let profile = ProfileService.shared.profile else {
            print("[profile] profile have not get")
            return nil
        }

        let username = profile.username
        print(username)

        return URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "Get",
            baseURLString: Constants.defaultBaseUrl)
    }

    func fetchProfileImageURL(
        username: String,
        completion: @escaping (Result<UserResult, NetworkError>) -> Void
    ) {

        guard let request = makeProfileImageURL() else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        if task != nil {
            print("[task] task not empty")
            completion(.failure(NetworkError.httpStatusCode(400)))
            return
        } else {
            print("[task] task is empty")
        }

        let task = URLSession.shared.dataTask(with: request) {
            [weak self] data, result, error in

            guard let self = self else { return }

            if let error = error {
                let networkError: NetworkError
                if let urlSessionError = error as? URLError {
                    networkError = NetworkError.urlRequestError(urlSessionError)
                } else {
                    networkError = NetworkError.urlSessionError(
                        "Неизвестная ошибка сессии")
                }
                print("[task] networkError is \(networkError)")
                completion(.failure(networkError))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[json] jsonstringImage: \(jsonString)")
            } else {
                print("[json] jsonstring error: invalid JSON image")
            }
            do {
                let userResult = try JSONDecoder().decode(
                    UserResult.self, from: data)

                // Извлекаем ссылку на маленькое изображение
                if let smallImageURL = userResult.profileImage?.small {
                    self.profileImageURL = URL(string: smallImageURL)
                    print("[task] url avatar has loaded: \(smallImageURL)")

                    DispatchQueue.main.async {
                        print("[task] send notification to load avatar")
                        NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: nil)
                    }
                } else {
                    print("[task] url avatar is empty")
                }

                completion(.success(userResult))
            } catch {
                print("[task] error form decoder: \(error)")
                completion(.failure(NetworkError.httpStatusCode(404)))
            }
        }
        self.task = task
        task.resume()
    }

    func clearProfileImage() {
        profileImageURL = nil
    }
}
