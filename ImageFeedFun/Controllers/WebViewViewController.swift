//
//  WebViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 17.09.2024.
//

import UIKit
@preconcurrency import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!

    weak var delegate: WebViewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[override func viewDidLoad] started")
        
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        
        webView.accessibilityIdentifier = "UnsplashWebView"
        view.addSubview(webView)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        presenter?.viewDidLoad()

    }

    @IBAction private func backButton(_ sender: Any?) {
        print("[backButton] started")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // NOTE: Since the class is marked as `final` we don't need to pass a context.
        // In case of inhertiance context must not be nil.
        print("[viewDidAppear] started")
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("[viewWillDisappear] started")
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("[override func observeValue] started")
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        print("[func updateProgress] started")
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        print("[func code] started")
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    func setProgressValue(_ newValue: Float) {
        print("[setProgressValue] started")
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        print("[setProgressHidden] started")
        progressView.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        print("[func load] started")
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate  {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        print("[extension webView] started")
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
