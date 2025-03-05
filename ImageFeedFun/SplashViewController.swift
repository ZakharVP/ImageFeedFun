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
        
        print("[SplashViewController] open main window")
        let nToken = storage.get()
        if let token = nToken, !token.isEmpty {
            fetchFullProfileAndGoToTabBarController(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vcAuth = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                print("[SplashViewController] error to create AuthenticationViewController!")
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
    
    func switchToTabBarController(){
        //UIApplication.windows must be used from main thread only
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("[switchToTabBarController] error to open first window")
                return
            }
            
            let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
            window.rootViewController = tabBarController
        }
    }
}


