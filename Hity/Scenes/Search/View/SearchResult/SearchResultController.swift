//
//  SearchResultController.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit

class SearchResultController: UIViewController {

    //MARK: - Properties
    
    private let searchResultView = SearchResultView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    //MARK: - ConfigureViewController
    
    private func configureViewController() {
        view = searchResultView
    }
    



   
}
