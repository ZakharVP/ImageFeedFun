//
//  AuthViewControllerDelegate.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 05.10.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
