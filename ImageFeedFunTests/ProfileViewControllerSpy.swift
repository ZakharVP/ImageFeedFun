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
    var isSwitchToSplashViewControllerCalled = false
    var presenter: ProfileViewPresenterProtocol?
    var showAlertCalled = false
    var presentedAlert: UIAlertController?


    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled = true
    }

    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
    }

    func switchToSplashViewController() {
        isSwitchToSplashViewControllerCalled = true
    }
    
    func showAlert(_ alert: UIAlertController) {
        showAlertCalled = true
        presentedAlert = alert // Сохраняем переданный алерт для проверки
       }
    
}

extension UIAlertAction {
    func performAction() {
        if let handler = self.value(forKey: "handler") as? () -> Void {
            handler()
        }
    }
}
