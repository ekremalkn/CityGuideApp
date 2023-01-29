//
//  SearchResultController.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultController: UIViewController {

    //MARK: - Properties
    
    private let searchResultView = SearchResultView()
    private let searchViewModel = SearchViewModel()
    
    var searchText = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    //MARK: - ConfigureViewController
    
    private func configureViewController() {
        view = searchResultView
        configureTableView()
    }
    
    
 
    private func configureTableView() {
        
        // bind places to tableview
        
        searchViewModel.places.bind(to: searchResultView.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, place, cell in
            cell.textLabel?.text = place.placeName
        }.disposed(by: disposeBag)
        
        // fetch places
        searchText.subscribe(onNext: { [weak self] text in
            self?.searchViewModel.fetchPlaces(text)
            
        }).disposed(by: disposeBag)
        
        // handle didselect
        
        searchResultView.tableView.rx.modelSelected(PlacesModel.self).bind(onNext: { place in
            print(place.placeName)

        }).disposed(by: disposeBag)
        
    }

    



   
}
