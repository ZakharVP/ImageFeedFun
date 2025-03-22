//
//  ProfileViewPresenter.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 21.03.2025.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

final class ProfilePresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileLogoutService: ProfileLogoutServiceProtocol
    private let oauth2TokenStorage: OAuth2TokenStorageProtocol
    
    private var profileImageServiceObserver: NSObjectProtocol?

    init(
          profileService: ProfileServiceProtocol = ProfileService.shared,
          profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared,
          oauth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
      ) {
          self.profileService = profileService
          self.profileLogoutService = profileLogoutService
          self.oauth2TokenStorage = oauth2TokenStorage
        
      }
    
    deinit {
        print("[ProfilePresenter] Deinitialized")
    }
    
    func viewDidLoad() {
         if let profile = profileService.profile {
             updateProfileDetails(profile: profile)
         }
        print("[ProfilePresenter - viewDidLoad] started")
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                print("[Observer] notifi is received")
                guard let self = self, let url = ProfileImageService.shared.profileImageURL else {
                    print("[observeAvatarChanges] URL is nil")
                    return
                }
                print("[observeAvatarChanges - updateAvatar] Updating avatar with URL: \(url)")
                self.updateAvatar(with: url)
            }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("[Observer] check send data")
            NotificationCenter.default.post(
                name: ProfileImageService.didChangeNotification, object: nil)
        }
        
     }
    
    func didTapLogoutButton() {
        
        // Создаем алерт с вопросом
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )

        // Действие "Да"
        let yesAction = UIAlertAction(title: "Да", style: .default) {
            [weak self] _ in
            guard let self = self else { return }

            // Удаляем токен из Keychain
            let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(
                forKey: "Auth token")
            if removeSuccessful {
                print("[didTapButton] key is removed form keychain")
            } else {
                print(
                    "[didTapButton] key could not to be removed form keychain")
            }

            // Очищаем все данные через сервис
            profileLogoutService.logout()

            // Переходим на стартовый экран (SplashViewController)
            view?.switchToSplashViewController()
        }
        
        // Действие "Нет"
        let noAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)

        // Добавляем действия в алерт
        alert.addAction(yesAction)
        alert.addAction(noAction)
        

        // Показываем алерт
        view?.showAlert(alert)
      }
    
    func updateProfileDetails(profile: Profile) {
        view?.updateProfileDetails(profile: profile)
     }

    func updateAvatar(with url: URL) {
        print("[updateAvatar] Updating avatar with URL: \(url)")
        view?.updateAvatar(with: url)
    }
}
