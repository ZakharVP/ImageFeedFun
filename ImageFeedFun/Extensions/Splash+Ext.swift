//
//  Splash+Ext.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 19.02.2025.
//
import Foundation

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        fetchFullProfileAndGoToTabBarController(code)
    }
    
    func fetchFullProfileAndGoToTabBarController(_ token: String) {
        print("[fetchFullProfileAndGoToTabBarController] begin fetch data profile")
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success:
                    print("[fetchProfile] data profile is received")
                    if let profileData = try? result.get() {
                        let nProfile = self.profile.init(result: profileData)
                        print("[fetchProfile] data profile is decoded")
                        ProfileService.shared.updateProfile(nProfile)
                        let username = nProfile.loginName
                        ProfileImageService.shared.fetchProfileImageURL(username: username ?? "") { _ in}
                    }
                    self.switchToTabBarController()
                    print("[fetchProfile] start fetch photos")
                    ImagesListService.shared.fetchPhotosNextPage()
                    
                case .failure:
                    print("[fetchProfile] error from received data profile!")
                    break
                }
            }
        }
    }
}
