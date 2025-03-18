//
//  PhotoResult+Ext.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 17.03.2025.
//
import Foundation

extension PhotoResult {
    func toPhoto() -> Photo {
        let iso8601DateFormatter = ISO8601DateFormatter()
        let createdAtDate = iso8601DateFormatter.date(from: createdAt)

        return Photo(
            id: id,
            size: CGSize(width: width ?? 0, height: height ?? 0),
            createdAt: createdAtDate,
            welcomdescription: description,
            thumbImageURL: urls?.thumb ?? "",
            largeImageURL: urls?.full ?? "",
            isLiked: likedByUser ?? false
        )
    }
}
