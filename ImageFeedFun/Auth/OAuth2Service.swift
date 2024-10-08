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
        
        let request = makeTokenRequest(code: code)
        
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
                guard let self else { preconditionFailure("self is unavalible") }
                
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
    
    func logError(_ error: NetworkError) {
        switch error{
        case .httpStatusCode(let code):
            print("HTTP Error: \(code)")
        case .urlRequestError(let requestError):
            print("URL Request Error: \(requestError.localizedDescription)")
        case .urlSessionError(let message):
            print("URL Session Error: \(message)")
        }
    }
    
    func makeTokenRequest(code: String) -> URLRequest {
        guard var urlComponents = URLComponents(string: OAuth2ServiceConstants.unsplashGetTokenURLString) else {
            preconditionFailure("invalide sheme or host name")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            preconditionFailure("Cannot make url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
