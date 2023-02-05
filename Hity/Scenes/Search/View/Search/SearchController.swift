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
        
        searchViewController.searchBar.rx.text.throttle(.seconds(2), scheduler: MainScheduler.instance).bind(onNext: { text in
            if let text = text {
                resultViewController.searchText.onNext(text)
            }
            
        }).disposed(by: disposeBag)
    }
}


//MARK: - SearchResultControllerDelegate

extension SearchController: SearchResultControllerDelegate {
    
    func didTapSearchLocation(_ coordinates: CLLocationCoordinate2D) {
        closeKeyboard()
        removeAnnotations()
        addAnnotations(coordinates, "Şu an bu konuma göre arama yapıyorsun.")
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
    
    func removeAnnotations(isNearbyPlace: Bool? = nil) {
        var annotations = searchView.mapView.annotations
        
        if let isNearbyPlace = isNearbyPlace {
            if isNearbyPlace {
                annotations.removeFirst()
                searchView.mapView.removeAnnotations(annotations)
            }
        }
        
        searchView.mapView.removeAnnotations(annotations)
        
    }
    
    func addAnnotations(_ coordinates: CLLocationCoordinate2D, _ placeUID: String? = nil, _ title: String? = nil, _ subTitle: String? = nil) {
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinates
        if let title = title {
            pin.title = title
        }
        if let placeUID = placeUID {
            pin.subtitle = placeUID
        }
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
    func didTapNearLocation(_ coordinates: CLLocationCoordinate2D, _ pinTitle: String, _ pinSubTitle: String) {
        closeKeyboard()
        removeAnnotations(isNearbyPlace: true)
        addAnnotations(coordinates, pinTitle, pinSubTitle)
        panel.move(to: .tip, animated: true)
    }
    
}











