//
//  SplashViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 04.10.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    
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
                print("Не удалось создать AuthenticationViewController в месте открытия ")
                return
            }
            vcAuth.delegate = self
            
            vcAuth.modalPresentationStyle = .fullScreen
            self.present(vcAuth, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    func showAlert(title: String, message: String) {
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
}


