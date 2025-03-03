//
//  Splash+Ext.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 19.02.2025.
//

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    func fetchFullProfileAndGoToTabBarController(_ token: String) {
        print("Начало получения данных о профиле")
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
                
            case .success:
                print("Данные профиля получены")
                if let profileData = try? result.get() {
                    let nProfile = self.profile.init(result: profileData)
                    print("Данные профиля разобраны")
                    ProfileService.shared.updateProfile(nProfile)
                    let username = nProfile.loginName
                    ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in}
                }
                self.switchToTabBarController()
                
            case .failure:
                print("Ошибка при получении профиля!")
                self.showAlert(title: "ОШИБКА", message: "Ошибка при получении профиля")
                break
            }
        }
    }
}
