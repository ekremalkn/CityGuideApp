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
        let viewControllers = [searchController(), favoriteControler()]
        setViewControllers(viewControllers, animated: true)
    }
    
    
    private func configureTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .blue
    }
    
    private func searchController() -> UINavigationController {
        let searchController = SearchController()
        searchController.title = "Hity"
        searchController.tabBarItem = UITabBarItem(title: "Hity", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        return UINavigationController(rootViewController: searchController)
    }
    
    private func favoriteControler() -> UINavigationController {
        let favoriteController = FavoriteController()
        favoriteController.title = "Favori"
        favoriteController.tabBarItem = UITabBarItem(title: "Favori", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        return UINavigationController(rootViewController: favoriteController)
    }
}
