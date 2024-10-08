//
//  SplashViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 04.10.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        // Проверка на наличие ключа
        if storage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = .blackColorFon
    }
    
    private func switchToTabBarController(){
        
        //Обернул выполнение в основной поток, так как после выполнения сетевого запроса получаю ошибку
        //UIApplication.windows must be used from main thread only
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            
            
            let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
            window.rootViewController = tabBarController
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchToken(code) { [weak self] result in
            guard let self else { preconditionFailure("Weak self error") }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                print("fetch token error \(error)")
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
}

extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for  \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


    


