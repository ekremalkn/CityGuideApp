//
//  SearchController.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit

final class SearchController: UIViewController {
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    
    //MARK: - UISearchController
    
    private let searchViewController = UISearchController(searchResultsController: SearchResultController())


    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - ConfigureViewController
    
    private func configureViewController() {
        view = searchView
        configureSearchController()
    }
    
    //MARK: - ConfigureSearchController
    
    private func configureSearchController() {
        searchViewController.searchBar.backgroundColor = .secondarySystemBackground
        navigationItem.searchController = searchViewController
    }


    


}
