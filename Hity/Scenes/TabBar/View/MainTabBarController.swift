//
//  MainTabBarController.swift
//  Hity
//
//  Created by Ekrem Alkan on 7.02.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        configureTabBar()
    }
    
    //MARK: - Configure TabBar
    
    private func setupTabBar() {
        let viewControllers = [containerController(), favoriteControler()]
        setViewControllers(viewControllers, animated: true)
    }
    
    private func configureTabBar() {
        tabBar.addShadow()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .blue
    }
    
    // Container contains Profile Controller and SerchController as a child
    private func containerController() -> UIViewController {
        let containerController = ContainerController()
        containerController.tabBarItem = UITabBarItem(title: "Hity", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        return containerController
    }
    
    private func favoriteControler() -> UINavigationController {
        let favoriteController = FavoriteController()
        favoriteController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        return UINavigationController(rootViewController: favoriteController)
    }
}
