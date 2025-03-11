//
//  ProfileResult.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 27.10.2024.
//

struct Profile: Codable {
    let username: String    // Логин
    let name: String        // Имя и Фамилия
    let loginName: String   // Логин со знаком @
    let bio: String?        // 
}
