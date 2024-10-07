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
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, any Error>) -> Void) {
        
        let request = makeOAuthTokenRequest(code: code)
        let task = urlSession.data(for: request) { [weak self] result in
            
            guard let self else { preconditionFailure("self is unavalible") }
            
            switch result {
            case .success(let data):
                
                do {
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
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
