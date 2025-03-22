//
//  ProfileViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 05.09.2024.
//

import Kingfisher
import SwiftKeychainWrapper
import UIKit

final class ProfileViewController: UIViewController,
    ProfileViewControllerProtocol
{

    var presenter: (any ProfileViewPresenterProtocol)?

    private var profileView: UIImageView?
    private var fullNameView: UILabel?
    private var mailView: UILabel?
    private var textView: UILabel?

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BlackColorFon")

        print("[ProfileViewController] Добавляем элементы на экран")

        addProfileImageView()
        addButtonExitView()
        addFullNameView()
        addMailView()
        addTextView()

        presenter?.view = self
        presenter?.viewDidLoad()

    }

    deinit {
        print("[ProfileViewController] Deinitialized")
    }

    @objc
    private func didTapButton() {
        presenter?.didTapLogoutButton()
    }

    func updateProfileDetails(profile: Profile) {
        print("[updateProfileDetails] Запущен")
        fullNameView?.text = profile.name
        mailView?.text = profile.loginName
    }

    func updateAvatar(with url: URL) {
        print("[updateAvatar] Запущен")
        DispatchQueue.main.async {
            self.profileView?.kf.setImage(
                with: url, placeholder: UIImage(named: "profile_placeholder"))
        }

    }

    func switchToSplashViewController() {
        let splashViewController = SplashViewController()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Не удалось получить окно")
            return
        }
        window.rootViewController = splashViewController
    }

    private func addProfileImageView() {

        let profileView = UIImageView()
        profileView.tintColor = .gray
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileView)

        profileView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 16
        ).isActive = true
        profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76)
            .isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 70).isActive = true

        self.profileView = profileView

    }

    private func addButtonExitView() {

        guard let exitIcon = UIImage(named: "log_out"),
            let profileViewOne = self.profileView
        else { return }

        let buttonExit = UIButton.systemButton(
            with: exitIcon,
            target: self,
            action: #selector(Self.didTapButton))

        buttonExit.tintColor = UIColor(named: "RedColorExitButton")
        buttonExit.translatesAutoresizingMaskIntoConstraints = false
        buttonExit.accessibilityIdentifier = "logout button"
        view.addSubview(buttonExit)

        buttonExit.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -16
        ).isActive = true
        buttonExit.centerYAnchor.constraint(
            equalTo: profileViewOne.centerYAnchor
        ).isActive = true
        buttonExit.widthAnchor.constraint(equalToConstant: 44).isActive = true
        buttonExit.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }

    private func addFullNameView() {

        guard let profileView = self.profileView else { return }
        let fullNameView = UILabel()
        fullNameView.textColor = .white
        fullNameView.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        fullNameView.translatesAutoresizingMaskIntoConstraints = false
        fullNameView.text = "Екатерина Новикова"
        view.addSubview(fullNameView)

        fullNameView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 16
        ).isActive = true
        fullNameView.topAnchor.constraint(
            equalTo: profileView.bottomAnchor, constant: 8
        ).isActive = true

        profileView.layer.cornerRadius = 35  // Половина от ширины и высоты, чтобы сделать круг
        profileView.layer.masksToBounds = true

        self.fullNameView = fullNameView

    }

    private func addMailView() {

        guard let fullNameView = self.fullNameView else { return }
        let mailView = UILabel()
        mailView.textColor = UIColor(named: "GrayColorEmailName")
        mailView.translatesAutoresizingMaskIntoConstraints = false
        mailView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        mailView.text = "@ekaterina_nov"
        view.addSubview(mailView)

        mailView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 16
        ).isActive = true
        mailView.topAnchor.constraint(
            equalTo: fullNameView.bottomAnchor, constant: 8
        ).isActive = true

        self.mailView = mailView

    }

    private func addTextView() {

        guard let mailView = self.mailView else { return }
        let textView = UILabel()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textView.text = "Hello, world"

        view.addSubview(textView)

        textView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 16
        ).isActive = true
        textView.topAnchor.constraint(
            equalTo: mailView.bottomAnchor, constant: 8
        ).isActive = true

    }
}

