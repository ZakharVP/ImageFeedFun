//
//  OAuth2Service.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 25.09.2024.
//

import Foundation

final class OAuth2Service {
    
    private let tokenStorage = OAuth2TokenStorage()
    static let shared = OAuth2Service()
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    
    private init() {}
    
    func fetchToken(_ code: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        //Так как теперь запрос может быть nil, мне нужно обработать это
        guard let request = makeTokenRequest(code: code) else {
            print("Error, request is nil \n")
            return
        }
        
        //TODO Сделать логирование ошибок в консоль // Блок 3. URLRequest
        //Ниже по коду через функцию logError вывожу в консоль ошибки
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                let networkError = NetworkError.urlRequestError(error)
                self?.logError(networkError)
                completion(.failure(networkError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NetworkError.urlSessionError("Invalid response type")
                self?.logError(error)
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NetworkError.httpStatusCode(httpResponse.statusCode)
                self?.logError(error)
                return
            }
            
            do {
                guard let self else { return }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let data = data {
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                }
            }
            catch {
                let parsingError = NetworkError.urlRequestError(error)
                self?.logError(parsingError)
                completion(.failure(parsingError))
            }
        }
        task.resume()
    }
    
    private func logError(_ error: NetworkError) {
        switch error{
        case .httpStatusCode(let code):
            print("HTTP Error: \n \(code)")
        case .urlRequestError(let requestError):
            print("URL Request Error: \n \(requestError.localizedDescription)")
        case .urlSessionError(let message):
            print("URL Session Error: \n \(message)")
        }
    }
    
    private func makeTokenRequest(code: String) -> URLRequest? {
        //TODO Сделать логирование ошибок в консоль // Блок 1. URLComponents
        guard var urlComponents = URLComponents(string: Constants.unsplashGetTokenURLString) else {
            print("invalide sheme or host name \n")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        //TODO Сделать логирование ошибок в консоль // Блок 2. URL
        guard let url = urlComponents.url else {
            print("Cannot make url \n")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
