//
//  Photo.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 08.03.2025.
//
import Foundation

struct Photo {
    
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomdescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool

}
