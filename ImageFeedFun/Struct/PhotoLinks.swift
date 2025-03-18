//
//  PhotoLinks.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 13.03.2025.
//

struct PhotoLinks: Codable {
    let html: String
    let download: String
    let downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case html
        case download
        case downloadLocation = "download_location"
    }
}
