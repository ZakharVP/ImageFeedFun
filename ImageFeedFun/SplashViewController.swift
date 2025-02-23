//
//  SplashViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 04.10.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    private let iView = UIImageView()
    private let button = UIButton(type: .system)
    
    let profileService = ProfileService.shared
    let profile = Profile.self
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        print("Открытие основного окна и выбор экрана от условий")
        let nToken = storage.get()
        if let token = nToken, !token.isEmpty {
            fetchFullProfileAndGoToTabBarController(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vcAuth = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                print("Не удалось создать AuthenticationViewController")
                return
            }
            vcAuth.delegate = self
            
            vcAuth.modalPresentationStyle = .fullScreen
            self.present(vcAuth, animated: true, completion: nil)
        }
      
        guard let vcAuth = storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            print("Не удалось создать AuthenticationViewController")
            return
        }
        vcAuth.delegate = self
            
        vcAuth.modalPresentationStyle = .fullScreen
        self.present(vcAuth, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
 
// Заготовка
//        addImageView()
//        addButton()
//        addConstraint()
        
    }
    
    private func addImageView() {
        
       
        iView.tintColor = .gray
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.image = UIImage(named: "auth_screen_logo")
        
        view.addSubview(iView)
        
    }
    
    private func addButton() {
        
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.black, for: .normal) // Текст кнопки белый
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .white // Измените цвет фона кнопки на синий (или любой другой)
        button.layer.cornerRadius = 8 // Закругление углов
        button.translatesAutoresizingMaskIntoConstraints = false // Включаем Auto Layout
        
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        
    }
    
    private func addConstraint() {
        
        NSLayoutConstraint.activate([
            iView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрирование по горизонтали
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
            ])
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
  
    func switchToTabBarController(){
        //UIApplication.windows must be used from main thread only
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Ошибка при открытии первого окна")
                return
            }
            
            let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
            window.rootViewController = tabBarController
        }
    }
    
    func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show() // ProgressHUD.animate()
        
        oauth2Service.fetchToken(code) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss() // ProgressHUD.dismiss()
            switch result {
            case .success:
                fetchFullProfileAndGoToTabBarController(code)
            case .failure(let error):
                print("Ошибка при получении токена \(error)")
                self.showAlert(title: "ОШИБКА", message: "Не удалось получить код доступа")
            }
        }
    }
 
    @objc private func onButtonTapped() {
        guard let vcAuth = storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            print("Не удалось создать AuthenticationViewController")
            return
        }
        vcAuth.delegate = self
        
        vcAuth.modalPresentationStyle = .fullScreen
        self.present(vcAuth, animated: true, completion: nil)
    }
}


