//
//  ProfileViewTests.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//

//
//  ImageFeedFunTests.swift
//  ImageFeedFunTests
//
//  Created by Захар Панченко on 20.03.2025.
//


@testable import ImageFeedFun
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testProfileViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled, "Метод viewDidLoad() презентера не был вызван")
    }

    func testProfileViewControllerCallsUpdateProfileDetails() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profileService: ProfileService.shared,
            profileLogoutService: ProfileLogoutService.shared,
            oauth2TokenStorage: OAuth2TokenStorage()
        )
        viewController.presenter = presenter
        presenter.view = viewController

        // When
        let profile = Profile(username: "test", name: "Test User", loginName: "@test", bio: "Test bio")
        presenter.updateProfileDetails(profile: profile)

        // Then
        XCTAssertTrue(viewController.updateProfileDetailsCalled, "Метод updateProfileDetails(profile:) не был вызван")
    }

    func testProfileViewControllerCallsUpdateAvatar() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profileService: ProfileService.shared,
            profileLogoutService: ProfileLogoutService.shared,
            oauth2TokenStorage: OAuth2TokenStorage()
        )
        viewController.presenter = presenter
        presenter.view = viewController

        // When
        let url = URL(string: "https://example.com/avatar.jpg")!
        presenter.updateAvatar(with: url)

        // Then
        XCTAssertTrue(viewController.updateAvatarCalled, "Метод updateAvatar(with:) не был вызван")
    }

    func testProfileViewControllerCallsSwitchToSplashViewController() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profileService: ProfileService.shared,
            profileLogoutService: ProfileLogoutService.shared,
            oauth2TokenStorage: OAuth2TokenStorage()
        )
        viewController.presenter = presenter
        presenter.view = viewController

        // When
        presenter.didTapLogoutButton()

        // Then
        XCTAssertTrue(viewController.switchToSplashViewControllerCalled, "Метод switchToSplashViewController() не был вызван")
    }
    
}


