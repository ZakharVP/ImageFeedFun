//
//  ProfileViewPresenterSpy.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//

import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    var view: ProfileViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
    
}
