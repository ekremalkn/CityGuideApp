//
//  MainTabBarController.swift
//  Hity
//
//  Created by Ekrem Alkan on 7.02.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        configureTabBar()
    }
    
    private func setupTabBar() {
        let viewControllers = [containerController(), favoriteControler()]
        setViewControllers(viewControllers, animated: true)
    }
    
    
    private func configureTabBar() {
        tabBar.addShadow()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .blue
    }
    
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
