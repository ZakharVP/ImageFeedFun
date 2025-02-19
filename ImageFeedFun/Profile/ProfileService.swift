//
//  ProfileService.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 17.10.2024.
//

import Foundation
import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private init() {}
    
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private(set) var profile: Profile?
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "Get",
            baseURLString: Constants.defaultBaseUrl)
    }
    
    private func logError(_ error: NetworkError) {
        switch error{
        case .httpStatusCode(let code):
            print("HTTP ошибка: \n \(code)")
        case .urlRequestError(let requestError):
            print("URL ошибка с запросом: \n \(requestError.localizedDescription)")
        case .urlSessionError(let message):
            print("URL ошибка с сессией: \n \(message)")
        case .invalidRequest:
            print("URL некоректный запрос по причине: \n")
        }
    }
    
    func updateProfile(_ profile: Profile) {
        self.profile = profile
    }
    
    func fetchProfile (_ token: String, completion: @escaping(Result<ProfileResult, NetworkError>) -> Void) {
        
        assert(Thread.isMainThread)
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        if task != nil {
            print("task не пустой")
            if lastCode != token {
                task?.cancel()
            } else {
                completion(.failure(NetworkError.httpStatusCode(400)))
                return
            }
            
        } else {
            print("task пустой")
            if lastCode == token {
                print("task пустой, но значение lastcode \(lastCode)")
                completion(.failure(NetworkError.httpStatusCode(400)))
                return
            }
        }
        
        lastCode = token
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            
            DispatchQueue.main.async{
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

