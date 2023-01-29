//
//  SearchController.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchController: UIViewController {
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    
    private let disposeBag = DisposeBag()
    
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
        
        guard let resultViewController = searchViewController.searchResultsController as? SearchResultController else { return }
        
        searchViewController.searchBar.rx.text.bind(onNext: { text in
            if let text = text {
                resultViewController.searchText.onNext(text)
            }
            
        }).disposed(by: disposeBag)
            
        }
        
    }
        

    



