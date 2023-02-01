//
//  SearchController.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit
import RxSwift
import MapKit


final class SearchController: UIViewController {
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel()
    
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
        resultViewController.delegate = self
        
        searchViewController.searchBar.rx.text.bind(onNext: { text in
            if let text = text {
                resultViewController.searchText.onNext(text)
            }
            
        }).disposed(by: disposeBag)
        
        
    }
    
}

extension SearchController: SearchResultControllerDelegate {
    func didTapLocation(_ coordinates: CLLocationCoordinate2D) {
        dismiss(animated: true) { [weak self] in
            self?.searchViewController.searchBar.resignFirstResponder()
            
            // remove all annotations
            
            if let annotations = self?.searchView.mapView.annotations {
                self?.searchView.mapView.removeAnnotations(annotations)
            }
            
            // add annotation
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            self?.searchView.mapView.addAnnotation(pin)
            let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self?.searchView.mapView.setRegion(region, animated: true)
        }
        
        
        
        
    }
    
    
}








