//
//  AuthViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 17.09.2024.
//

import UIKit

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let iView = UIImageView()
    private let button = UIButton(type: .system)
    
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        addImageView()
        addButton()
        addConstraint()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .white // Измените цвет фона кнопки на синий (или любой другой)
        button.layer.cornerRadius = 16 // Закругление углов
        button.translatesAutoresizingMaskIntoConstraints = false // Включаем Auto Layout
        
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        
    }
    
    private func addConstraint() {
        
        NSLayoutConstraint.activate([
            iView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.widthAnchor.constraint(equalToConstant: 343),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
        ])
        
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "BlackColorFon")
    }
    
    func fetchOAuthToken(_ code: String) {
        //UIBlockingProgressHUD.show()
        
        oauth2Service.fetchToken(code) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                //UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let token):
                    print("[fetchToken] token is received \(token)")
                    self.delegate?.authViewController(self, didAuthenticateWithCode: token)
                case .failure(let error):
                    print("[fetchToken] error from receiving token is \(error)")
                    self.showAlert(title: "ОШИБКА", message: "Не удалось получить код доступа")
                }
            }
        }
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        fetchOAuthToken(code)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc private func onButtonTapped() {
        
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        webViewViewController.modalPresentationStyle = .fullScreen
        present(webViewViewController, animated: true, completion: nil)
        
    }
}
