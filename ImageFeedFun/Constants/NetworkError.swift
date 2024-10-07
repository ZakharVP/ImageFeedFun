//
//  NetworkError.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 07.10.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
