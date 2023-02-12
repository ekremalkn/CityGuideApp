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
import CoreLocation


final class SearchController: UIViewController {
    
    //MARK: - Properties
    
    private let searchView = SearchView()
    private let panel = FloatingPanelController()
    private let locationManager = CLLocationManager()
    
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
        customizeNavBar()
        setupUserLocation()
    }
    
    //MARK: - ConfigureSearchController
    
    private func configureSearchController() {
        searchViewController.searchBar.backgroundColor = .clear
        searchViewController.searchBar.placeholder = "Şu an bulunduğun konumu yaz ve seç"
        navigationItem.searchController = searchViewController
        reactiveUISearchController()
    }
    
    //MARK: - Customize NavBar
    
    private func customizeNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchView.leftButton)
        self.navigationItem.titleView = searchView.locationButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchView.profileButton)
    }

    
}

//MARK: - Reactive UISearchController

extension SearchController {
    
    func reactiveUISearchController() {
        
        guard let resultViewController = searchViewController.searchResultsController as? SearchResultController else { return }
        resultViewController.searchResultControllerDelegate = self
        self.placeNameCallbacks(resultViewController)
        searchViewController.searchBar.rx.text.throttle(.seconds(2), scheduler: MainScheduler.instance).bind(onNext: { text in
            if let text = text {
                resultViewController.searchText.onNext(text)
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func placeNameCallbacks(_ controller: SearchResultController) {
        controller.placeName.bind { [weak self] placeName in
            self?.searchView.locationButton.setTitle(placeName, for: .normal)
        }.disposed(by: disposeBag)
    }
}


//MARK: - SearchResultControllerDelegate

extension SearchController: SearchResultControllerDelegate {
    
    func didTapSearchLocation(_ coordinates: CLLocationCoordinate2D) {
        
        closeKeyboard()
        removeAnnotations()
        addAnnotations(coordinates, "Bu konumun etrafında arama yapıyorsun", "")
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
    
    func addAnnotations(_ coordinates: CLLocationCoordinate2D, _ title: String? = nil, _ subTitle: String? = nil) {
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinates
        
        if let title = title {
            pin.title = title
        }
        
        if let subTitle = subTitle {
            pin.subtitle = subTitle
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


//MARK: - User Current Location

extension SearchController: CLLocationManagerDelegate {
    
    
    private func setupUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationButtonCallback()
    }
    
    private func locationButtonCallback() {
        searchView.locationButton.rx.tap.bind { [weak self] value in
            // location updates when the user tap button
                self?.locationManager.startUpdatingLocation()
                        
        }.disposed(by: disposeBag)
        
    }

        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Handle changes if location permissions

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location update
        if let location = locations.last {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] placeMarks, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let placeMark = placeMarks?.last {
                    if let placeName = placeMark.locality {
                        self?.searchView.locationButton.setTitle(placeName, for: .normal)
                    } else {
                        self?.searchView.locationButton.setTitle("Current location", for: .normal)
                    }
                }
            }
            removeAnnotations()
            addAnnotations(coordinates)
            createFloatingPanel(coordinates)
            }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
        print("Kullanıcı konumuna erişemedik \(error.localizedDescription)")
    }
    
    
}











