//
//  WebViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 17.09.2024.
//

import UIKit
@preconcurrency import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

final class WebViewViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    weak var delegateSplashVC: SplashViewController?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
              progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
          ])
        
        loadAuthView()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        }
    
    @IBAction private func backButton(_ sender: Any?) {
        //delegate?.webViewViewControllerDidCancel(_vc: self)
        dismiss(animated: true, completion: nil)
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView(){
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("Ошибка иницализации urlComponents")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id",     value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri",  value: Constants.redirectURL),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope",         value: Constants.accessScope),
        ]
        guard let url = urlComponents.url else {
            print("Ошибка открытия ссылки")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewViewController {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
        {
            return codeItem.value
        } else {
            debugPrint("Код не получен")
            return nil
        }
    }
}

