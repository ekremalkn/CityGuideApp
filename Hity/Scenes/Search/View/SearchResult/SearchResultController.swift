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

protocol SearchResultControllerDelegate: AnyObject {
    func didTapSearchLocation(_ coordinates: CLLocationCoordinate2D)
}

final class SearchResultController: UIViewController {
    
    //MARK: - Properties
    
    weak var searchResultControllerDelegate: SearchResultControllerDelegate?
    private let searchResultView = SearchResultView()
    private let searchViewModel = SearchViewModel()
    
    var searchText = PublishSubject<String>()
    var placeName = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    //MARK: - ConfigureViewController
    
    private func configureViewController() {
        view = searchResultView
        configureTableView()
        didFetchCoordinate()
    }
    
    
    
    private func configureTableView() {
        
        // bind places to tableview
        
        searchViewModel.places.bind(to: searchResultView.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { [weak self] row, place, cell in
            self?.searchResultView.configureCellProperties(cell)
            cell.textLabel?.text = place.placeName
        }.disposed(by: disposeBag)
        
        // fetch places
        searchText.subscribe(onNext: { [weak self] text in
            self?.searchViewModel.fetchPlaces(text)
            
        }).disposed(by: disposeBag)
        
        // handle didselect
        searchResultView.tableView.rx.modelSelected(PlacesModel.self).bind(onNext: { [weak self] place in
            self?.searchViewModel.fetchCoordinates(place.placeUID)
            self?.placeName.onNext(place.placeName)
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Pin location on map
    
    private func didFetchCoordinate() {
        
        searchViewModel.coordinates.subscribe(onNext: { [weak self] coordinates in
            self?.searchResultControllerDelegate?.didTapSearchLocation(coordinates)
        }).disposed(by: self.disposeBag)
        
        
    }
    
    
}


