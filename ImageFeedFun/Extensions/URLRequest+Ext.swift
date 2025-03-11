//
//  URLRequest+Ext.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 27.10.2024.
//
import Foundation

extension URLRequest {

    static func makeHTTPRequest(
        path: String, httpMethod: String, baseURLString: String
    ) -> URLRequest? {
        guard
            let url = URL(string: baseURLString),
            let baseURL = URL(string: path, relativeTo: url)
        else { return nil }

        var request = URLRequest(url: baseURL)
        request.httpMethod = httpMethod

        if let token = OAuth2TokenStorage().get() {
            request.setValue(
                "Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

}
