//
//  FavoriteController.swift
//  Hity
//
//  Created by Ekrem Alkan on 7.02.2023.
//

import UIKit

final class FavoriteController: UIViewController {

    
    //MARK: - Properties
    
    private let favoriteView = FavoriteView()

    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = favoriteView
    }


}
