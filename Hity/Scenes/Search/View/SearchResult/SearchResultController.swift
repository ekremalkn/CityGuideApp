//
//  SearchResultController.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class SearchResultController: UIViewController {
    
    //MARK: - Properties
    
    private let searchResultView = SearchResultView()
    private let searchViewModel = SearchViewModel()
    
    var searchText = PublishSubject<String>()
    var coordinate = PublishSubject<CLLocationCoordinate2D>()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        didFetchCoordinate()
        
    }
    
    
    //MARK: - ConfigureViewController
    
    private func configureViewController() {
        view = searchResultView
        configureTableView()
    }
    
    
    
    private func configureTableView() {
        
        // bind places to tableview
        
        searchViewModel.places.bind(to: searchResultView.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { [weak self] row, place, cell in
            self?.searchResultView.tableView.isHidden = false
            cell.textLabel?.text = place.placeName
        }.disposed(by: disposeBag)
        
        // fetch places
        searchText.subscribe(onNext: { [weak self] text in
            self?.searchViewModel.fetchPlaces(text)
            
        }).disposed(by: disposeBag)
        
        // handle didselect
        
        searchResultView.tableView.rx.modelSelected(PlacesModel.self).bind(onNext: { [weak self] place in
            self?.searchResultView.tableView.isHidden = true
            self?.searchViewModel.fetchCoordianates(place.placeUID)
            
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Pin location on map
    
    private func didFetchCoordinate() {
        let searchController = SearchController()
        searchViewModel.coordinate.subscribe(onNext: { coordinate in
            searchController.pinLocationOnMap(coordinate)
        }).disposed(by: disposeBag)
    }
    
    
}
