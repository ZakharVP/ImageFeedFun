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
                    ProfileImageService.shared.fetchProfileImageURL(from: profileData.profileImage?.medium ?? "http://placehold.it/150x150") {}
                }
                self.switchToTabBarController()
                
            case .failure:
                print("Ошибка при получении профиля!")
                break
            }
        }
    }
}
