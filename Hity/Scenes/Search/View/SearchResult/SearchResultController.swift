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
    
    //MARK: - Constants
    
    private let searchResultView = SearchResultView()
    let searchResultViewModel = SearchResultViewModel()
    
    //MARK: - Observable Variables

    let placeName = PublishSubject<String>()
    let didTapSearchLocation = PublishSubject<CLLocationCoordinate2D>()

    let searchPlacesListed = PublishSubject<Bool>()
    //MARK: - Dispose Bag

    private (set) var disposeBag = DisposeBag()
    
   
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    //MARK: - ConfigureViewController
    
    private func configureViewController() {
        view = searchResultView
        createCallbacks()
    }
    
    private func createCallbacks() {
        createSearchResultViewModelCallbacks()
        configureTableView()
    }
    
    
    //MARK: - Create SearchResultViewModelCallbacks
    
    private func createSearchResultViewModelCallbacks() {
        
        // Fetched coordinate
        searchResultViewModel.coordinates.subscribe(onNext: { [weak self] coordinates in
            self?.didTapSearchLocation.onNext(coordinates)
        }).disposed(by: self.disposeBag)
        
        
        
    }
    
    //MARK: - Configure TableView

    private func configureTableView() {
        
        // bind places to tableview
        
        searchResultViewModel.places.bind(to: searchResultView.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { [weak self] row, place, cell in
            self?.searchResultView.configureCellProperties(cell)
            cell.textLabel?.text = place.placeName
            self?.searchPlacesListed.onNext(true)
        }.disposed(by: disposeBag)
        
        // fetch places
        //request sent from search controller when search bar text change
        
        // handle didselect
        searchResultView.tableView.rx.modelSelected(PlacesModel.self).bind(onNext: { [weak self] place in
            self?.searchResultViewModel.fetchCoordinates(place.placeUID)
            self?.placeName.onNext(place.placeName)
        }).disposed(by: disposeBag)
        
    }
    
}


