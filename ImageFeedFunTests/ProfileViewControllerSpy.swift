//
//  ProfileViewControllerSpy.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var switchToSplashViewControllerCalled = false
    var presenter: ProfileViewPresenterProtocol?
    var showAlertCalled = false
    var passedAlert: UIAlertController?


    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled = true
    }

    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
    }

    func switchToSplashViewController() {
        switchToSplashViewControllerCalled = true
    }
    
    func showAlert(_ alert: UIAlertController) {
           showAlertCalled = true
           passedAlert = alert // Сохраняем переданный алерт для проверки
       }
    
}
