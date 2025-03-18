//
//  TabBarController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 19.02.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
       
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "chel"),
            selectedImage: nil
        )
        setupTabBarAppearance()
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
    private func setupTabBarAppearance() {
          
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BlackColorFon") // Черный фон
              
        // Применяем настройки для стандартного и скролл-состояния
        tabBar.standardAppearance = appearance
      }
}
