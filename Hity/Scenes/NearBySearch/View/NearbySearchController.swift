//
//  NearbySearchController.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import UIKit
import RxSwift

protocol NearbySearchControllerDelegate: AnyObject {
    func didTapLocation()
}

final class NearbySearchController: UIViewController {
    
    
    //MARK: - Properties
    weak var delegate: NearbySearchControllerDelegate?
    private let nearBySearchView = NearbySearchView()
    private let nearBySearchViewModel = NearbySearchViewModel()
    
    var searchText = PublishSubject<String>()
    var lat: String
    var lng: String
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Init Methods

    init(lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        view = nearBySearchView
        reactiveTextField()
        configureTableView()
    }
    
    
    private func configureTableView() {
        
        //bind near places to tableview
        
        nearBySearchViewModel.nearPlaces.bind(to: nearBySearchView.tableView.rx.items(cellIdentifier: NearbyPlacesCell.identifier, cellType: NearbyPlacesCell.self)) { row, nearPlaces, cell in
            
            cell.configure(nearPlaces)
            
        }.disposed(by: disposeBag)
        
        // fetch nearPlaces
        
        searchText.subscribe(onNext: { [weak self] text in
            if let lat = self?.lat, let lng = self?.lng {
                self?.nearBySearchViewModel.fetchNearPlaces(text, lat, lng)
            }
        }).disposed(by: disposeBag)
        
        
        // handle didselect
        
        nearBySearchView.tableView.rx.modelSelected(Result.self).bind(onNext: { [weak self] place in
            self?.delegate?.didTapLocation()
        }).disposed(by: disposeBag)
        
        nearBySearchView.tableView.rx.rowHeight.onNext(150)
    }
    
    
    
    
}


//MARK: - Reactive TextField

extension NearbySearchController {
    
    func reactiveTextField() {
        
        nearBySearchView.textField.rx.text.bind(onNext: { [weak self] text in
            if let text = text, !text.isEmpty {
                self?.searchText.onNext(text)
            }
        }).disposed(by: disposeBag)
        
    }
}




