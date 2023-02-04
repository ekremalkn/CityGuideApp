//
//  SearchController.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit
import RxSwift
import MapKit
import FloatingPanel


final class SearchController: UIViewController {
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel()
    private let panel = FloatingPanelController()
    
    
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
        //        title = "Say Hi to City"
        //        navigationController?.navigationBar.prefersLargeTitles = true
        view = searchView
        configureSearchController()
    }
    
    //MARK: - ConfigureSearchController
    
    private func configureSearchController() {
        searchViewController.searchBar.backgroundColor = .clear
        searchViewController.searchBar.placeholder = "Şu an bulunduğun konumu yaz ve seç"
        navigationItem.searchController = searchViewController
        reactiveUISearchController()
    }
    
}

//MARK: - Reactive UISearchController

extension SearchController {
    
    func reactiveUISearchController() {
        
        guard let resultViewController = searchViewController.searchResultsController as? SearchResultController else { return }
        resultViewController.searchResultControllerDelegate = self
        
        searchViewController.searchBar.rx.text.bind(onNext: { text in
            if let text = text {
                resultViewController.searchText.onNext(text)
            }
            
        }).disposed(by: disposeBag)
    }
}


//MARK: - SearchResultControllerDelegate

extension SearchController: SearchResultControllerDelegate {
    func didTapLocation(_ coordinates: CLLocationCoordinate2D) {
        closeKeyboard()
        removeAllAnnotations()
        addAnnotations(coordinates)
        createFloatingPanel(coordinates)
    }
 
}

//MARK: - Annotations

extension SearchController {
    
    func closeKeyboard() {
        
        searchViewController.searchResultsController?.dismiss(animated: true) { [weak self] in
            self?.searchViewController.searchBar.resignFirstResponder()
        }
    }
    
    func removeAllAnnotations() {
        
        let annotations = searchView.mapView.annotations
        searchView.mapView.removeAnnotations(annotations)
    }
    
    func addAnnotations(_ coordinates: CLLocationCoordinate2D) {
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        searchView.mapView.addAnnotation(pin)
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        searchView.mapView.setRegion(region, animated: true)
    }
    
}


//MARK: - FloatingPanel for Nearby SearchController

extension SearchController {
    func createFloatingPanel(_ coordinates: CLLocationCoordinate2D) {
        
        let lat = "\(coordinates.latitude)"
        let lng = "\(coordinates.longitude)"
        
        let nearbySearchController = NearbySearchController(lat: lat, lng: lng)
        nearbySearchController.delegate = self
        
        panel.set(contentViewController: nearbySearchController)
        panel.addPanel(toParent: self)
    }
    
}

//MARK: - NearbySearchControllerDelegate

extension SearchController: NearbySearchControllerDelegate {
    func didTapLocation() {
        
        panel.move(to: .tip, animated: true)
    }
    
    
}









