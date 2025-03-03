//
//  URLSession+Ext.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 17.02.2025.
//

import UIKit

extension URLSession {
    
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void ) -> URLSessionTask {
        
        let task = self.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
                           
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("jsonstring: \(jsonString)")
                } else {
                    print("Error: invalid JSON")
                }
                
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodeObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodeObject))
                } catch {
                    completion(.failure(error))
                }
        }
        
        task.resume()
        return task
    }
    
    func imageTask (for request: URLRequest, completion: @escaping (Result<UIImage, Error>) -> Void ) -> URLSessionDataTask {
        let task = self.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(URLError(.badServerResponse)))
            }
        }
        task.resume()
        return task
    }
}
