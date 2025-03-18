//
//  ProfileLogoutService.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 16.03.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()

    private init() {}

    func logout() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
        ) { records in

            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes, for: [record],
                    completionHandler: {})

            }
        }

        // Очистка данных профиля
        ProfileService.shared.clearProfile()

        // Очистка данных аватара
        ProfileImageService.shared.clearProfileImage()

        // Очистка данных в ImageListService
        ImagesListService.shared.clearData()

    }
}
