//
//  OAuth2Service.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 25.09.2024.
//

import UIKit

final class OAuth2Service {
    
    private let tokenStorage = OAuth2TokenStorage()
    static let shared = OAuth2Service()
    private let decoder = JSONDecoder()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchToken(_ code: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        assert(Thread.isMainThread)
        
        UIBlockingProgressHUD.show()
        
        guard let request = makeTokenRequest(code: code) else {
            UIBlockingProgressHUD.dismiss()
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        if task != nil {
            print("task не пустой")
            if lastCode != code {
                task?.cancel()
            } else {
                UIBlockingProgressHUD.dismiss()
                completion(.failure(NetworkError.httpStatusCode(400)))
                return
            }
            
        } else {
            print("task пустой")
            if lastCode == code {
                print("task пустой, но значение lastcode \(lastCode)")
                UIBlockingProgressHUD.dismiss()
                completion(.failure(NetworkError.httpStatusCode(400)))
                return
            }
        }
        lastCode = code
        guard let request = makeTokenRequest(code: code) else {
            UIBlockingProgressHUD.dismiss()
            completion(.failure(NetworkError.httpStatusCode(400)))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            
            DispatchQueue.main.async{
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let responseBody):
                    self?.tokenStorage.set(newValue: responseBody.accessToken)
                    completion(.success(responseBody.accessToken))
                case .failure(let error):
                    let networkError: NetworkError
                    if let urlSessionError = error as? URLError {
                        networkError = NetworkError.urlRequestError(urlSessionError)
                    } else if let decodingError = error as? DecodingError {
                        networkError = NetworkError.urlRequestError(decodingError)
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
    
    private func makeTokenRequest(code: String) -> URLRequest? {
        //TODO Сделать логирование ошибок в консоль // Блок 1. URLComponents
        guard var urlComponents = URLComponents(string: Constants.unsplashGetTokenURLString) else {
            print("Неправильное имя хоста \n")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Не могу создать URL")
            print("Ошибка при создании url \n")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    

}
