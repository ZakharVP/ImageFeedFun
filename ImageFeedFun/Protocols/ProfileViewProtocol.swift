//
//  ProfileViewProtocol.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//
import UIKit

public protocol ProfileViewPresenterProtocol {
    func viewDidLoad()
    func didTapLogoutButton()
    var view: ProfileViewControllerProtocol? { get set }
}

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile)
    func updateAvatar(with url: URL)
    func showAlert(_ alert: UIAlertController)
    func switchToSplashViewController()
}

protocol ProfileServiceProtocol {
    var profile: Profile? { get }
}

protocol ProfileImageServiceProtocol {
    var profileImageURL: URL? { get }
    static var didChangeNotification: Notification.Name { get }
}

protocol ProfileLogoutServiceProtocol {
    func logout()
}

protocol OAuth2TokenStorageProtocol {
    func removeToken(forKey key: String) -> Bool
}
