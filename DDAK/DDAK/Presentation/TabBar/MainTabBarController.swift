//
//  MainTabBarController.swift
//  DDAK
//
//  Created by taekki on 2022/08/28.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let tabItems = TabBarItem.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        configureTabBarController()
        configureTabBarAppearance()
    }
}

extension MainTabBarController {
    
    private func configureTabBarController() {
        let contentViewControllers = [
            UINavigationController(rootViewController: ListViewController()),
            UINavigationController(rootViewController: PhotoSearchViewController()),
            UINavigationController(rootViewController: SettingViewController()),
        ]
        
        contentViewControllers.indices.forEach {
            contentViewControllers[$0].tabBarItem = self.tabItems[$0].toTabBarItem()
            contentViewControllers[$0].tabBarItem.tag = $0
        }
        
        setViewControllers(contentViewControllers, animated: true)
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(red: 249/255, green: 245/255, blue: 235/255, alpha: 1)
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
        tabBar.layer.shadowColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1).cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarImageView = tabBar.subviews[item.tag + 1].subviews.compactMap({ $0 as? UIImageView }).first else { return }
        
        DispatchQueue.main.async {
            tabBarImageView.alpha = 0.3
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                tabBarImageView.alpha = 1.0
            }
        }
    }
}
