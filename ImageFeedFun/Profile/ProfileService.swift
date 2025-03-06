//
//  ProfileService.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 17.10.2024.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private(set) var profile: Profile?
    private init() {}
    
    private func makeProfileRequest() -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "Get",
            baseURLString: Constants.defaultBaseUrl)
    }
    
    private func logError(_ error: NetworkError) {
        switch error{
        case .httpStatusCode(let code):
            print("[task]: network error, status code: \n \(code)")
        case .urlRequestError(let requestError):
            print("[task]: network error with request: \n \(requestError.localizedDescription)")
        case .urlSessionError(let message):
            print("[task]: network error with session: \n \(message)")
        case .invalidRequest:
            print("[task]: network error invalid request: \n")
        }
    }
    
    func updateProfile(_ profile: Profile) {
        self.profile = profile
    }
    
    func fetchProfile (_ token: String, completion: @escaping(Result<ProfileResult, NetworkError>) -> Void) {
        
        print("[fetchProfile] fetchProfile is run")
        guard let request = makeProfileRequest() else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        if task != nil {
            print("[task] task not empty")
            if lastCode != token {
                task?.cancel()
            } else {
                completion(.failure(NetworkError.httpStatusCode(400)))
                return
            }
            
        } else {
            print("[task] task is empty")
            if lastCode == token {
                print("[task] task is empty and lastcode = \(lastCode)")
                completion(.failure(NetworkError.httpStatusCode(400)))
                return
            }
        }
        
        lastCode = token
        UIBlockingProgressHUD.show()
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            
            DispatchQueue.main.async{
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let responseBody):
                    completion(.success(responseBody))
                case .failure(let error):
                    let networkError: NetworkError
                    if let urlSessionError = error as? URLError {
                        networkError = NetworkError.urlRequestError(urlSessionError)
                    } else {
                        networkError = NetworkError.urlSessionError("Неизвестная ошибка сессии")
                    }
                    self?.logError(networkError)
                    completion(.failure(networkError))
                }
                
                self?.task = nil
                self?.lastCode = nil
            }
        }
        
        self.task = task
        task.resume()
    }
}

