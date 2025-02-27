//
//  ProfileViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 05.09.2024.
//

import UIKit
import SwiftKeychainWrapper
import Kingfisher

final class ProfileViewController: UIViewController {

    private let storage = OAuth2TokenStorage()
    private let profileImageService = ProfileImageService()
    
    private var profileView: UIImageView?
    private var fullNameView: UILabel?
    private var mailView: UILabel?
    private var textView: UILabel?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BlackColorFon")
        
        addProfileImageView()
        addButtonExitView()
        addFullNameView()
        addMailView()
        addTextView()
        
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                print("Уведомление получено")
                guard let self = self else {
                    print("self is nil, контроллер был освобожден")
                    return
                }
                print("self существует, обновляем аватар")
                self.updateAvatar()
            }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("Проверка отправки наблюдателя. Отправляем уведомление")
            NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
        }
        
    }
    private func updateAvatar() {
        print("Получаем ссылку и загружаем профиль")
        guard let profileURL = ProfileImageService.shared.profileImageURL else { return}
        profileView?.kf.setImage(with: profileURL)
    }
    private func updateProfileDetails(profile: Profile) {
        fullNameView?.text  = profile.name
        mailView?.text      = profile.loginName
    }
        
    private func addProfileImageView() {
        
        guard let profileImage = UIImage(named: "profile_photo") else { return}
        let profileView = UIImageView(image: profileImage)
        profileView.tintColor = .gray
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileView)
        
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.profileView = profileView
        
    }
    
    private func addButtonExitView() {
        
        guard let exitIcon = UIImage(named: "log_out"),
              let profileViewOne = self.profileView  else { return }
        
        let buttonExit = UIButton.systemButton(
            with: exitIcon,
            target: self,
            action: #selector(Self.didTapButton))
        
        buttonExit.tintColor = UIColor(named: "RedColorExitButton")
        buttonExit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonExit)
        
        buttonExit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        buttonExit.centerYAnchor.constraint(equalTo: profileViewOne.centerYAnchor).isActive = true
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
        
        fullNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        fullNameView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 8).isActive = true
        
        profileView.layer.cornerRadius = 35 // Половина от ширины и высоты, чтобы сделать круг
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
        
        mailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mailView.topAnchor.constraint(equalTo: fullNameView.bottomAnchor, constant: 8).isActive = true
        
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
        
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textView.topAnchor.constraint(equalTo: mailView.bottomAnchor, constant: 8).isActive = true
        
    }
    
    @objc
    private func didTapButton() {
        //TODO "Something"
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token")
        if removeSuccessful {
            print("Ключ удален из хранилища")
        } else {
            print("Ключ не получилось удалить из хранилища")
        }
    }
}
