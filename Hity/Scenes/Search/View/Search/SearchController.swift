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
    
    
    //MARK: - Annotation Type
    
    enum AnnotationType {
        case userAnnotation
        case placeAnnotation
    }
    
    //MARK: - Constants
    
    let searchView = SearchView()
    let userDataViewModel = UserDataViewModel()
    private let locationManager = CLLocationManager()
    
    //MARK: - Disposebag
    
    let disposeBag = DisposeBag()
    
    
    // Floating Panel
    let panel = FloatingPanelController()
    
    // PlaceImage For CustomAnnotationView
    var placeImage: String?
    var profileImageURL: String?
    
    //MARK: - UISearchController
    
    private let uiSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultController())
        searchController.searchBar.searchTextField.backgroundColor = .black.withAlphaComponent(0.2)
        return searchController
    }()
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - ConfigureViewController
    
    private func configureViewController() {
        view.backgroundColor = .clear
        addSubview()
        setupConstraints()
        searchView.mapView.delegate = self
        createCallbacks()
        fetchUserData()
        configureNavBar()
        configureUISearchController()
        setupUserLocation()
    }
    
    private func configureNavBar() {
        title = "Say Hi to City"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchView.leftButton)
        self.navigationItem.titleView = searchView.navBarLocationButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchView.rightImageView)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func configureUISearchController() {
        uiSearchController.searchBar.placeholder = "Where are you / where will you be?"
        navigationItem.searchController = uiSearchController
        
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        createSearchViewButtonCallbacks()
        createUserDataViewModelCallbacks()
        createSearchResultControllerCallbacks()
    }
    
    //MARK: - Fetch User Display Data
    
    private func fetchUserData() {
        userDataViewModel.fetchProfilePhoto()
    }
    
    
    //MARK: - Create SearchView Button Callbacks
    
    private func createSearchViewButtonCallbacks() {
        
        // Navigation Bar Location Button
        searchView.navBarLocationButton.rx.tap.bind { [weak self] value in
            // location updates when the user tap button
            self?.locationManager.startUpdatingLocation()
            
        }.disposed(by: disposeBag)
        
    }
    
    
    //MARK: - Create UserDataViewModel Callbacks
    
    private func createUserDataViewModelCallbacks() {
        
        // Fetching User Data
        userDataViewModel.isDownloadingURLSuccess.subscribe(onNext: { [weak self] profileImageURL in
            self?.profileImageURL = profileImageURL
            self?.searchView.rightImageView.downloadSetImage(type: .onlyURL, url: profileImageURL)
            
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Create SearchResultController Callbacks
    
    
    func createSearchResultControllerCallbacks() {
        
        guard let searchResultController = uiSearchController.searchResultsController as? SearchResultController else { return }
        
        // Search Location Tap Callback
        searchResultController.didTapSearchLocation.subscribe { [weak self] coordinates in
            self?.placeImage = nil
            self?.closeKeyboard()
            self?.removeAnnotations(isNearbyPlace: false)
            self?.addAnnotations(coordinates, annotationType: .userAnnotation)
            self?.createFloatingPanel(coordinates)
        }.disposed(by: searchResultController.disposeBag)
        
        // Fetch Places Success
        
        searchResultController.searchPlacesListed.subscribe { [weak self] value in
            if value {
                self?.uiSearchController.searchBar.searchTextField.backgroundColor = nil
            }
        }.disposed(by: searchResultController.disposeBag)
        
        // Get Search Place Name and Set Location Button Title
        searchResultController.placeName.subscribe(onNext: { [weak self] placeName in
            self?.searchView.navBarLocationButton.setTitle(placeName, for: .normal)
        }).disposed(by: searchResultController.disposeBag)
        
        
        //MARK: - UISearchController SearchBar Callback
        // Used throttle to avoid send multiple request
        uiSearchController.searchBar.rx.text.throttle(.seconds(2), scheduler: MainScheduler.instance).bind(onNext: { text in
            if let text = text {
                searchResultController.searchResultViewModel.fetchPlaces(text)
            }
        }).disposed(by: disposeBag)
        
        
        uiSearchController.searchBar.rx.textDidEndEditing.subscribe(onNext: { [weak self] in
            self?.uiSearchController.searchBar.searchTextField.backgroundColor = .black.withAlphaComponent(0.2)
        }).disposed(by: disposeBag)
        
    }
    
    
}

//MARK: - Create FloatingPanel for Nearby SearchController

extension SearchController {
    
    func createFloatingPanel(_ coordinates: CLLocationCoordinate2D) {
        
        let lat = coordinates.latitude
        let lng = coordinates.longitude
        
        let nearbySearchController = NearbySearchController(lat: lat, lng: lng)
        panel.set(contentViewController: nearbySearchController)
        panel.addPanel(toParent: self)
        
        
        nearbySearchController.didTapNearbyCellLocationButton.subscribe(onNext: { [weak self] placeInfos in
            //annotation management and floating panel move
            self?.closeKeyboard()
            self?.removeAnnotations(isNearbyPlace: true)
            self?.addAnnotations(placeInfos["coordinates"] as! CLLocationCoordinate2D, annotationType: .placeAnnotation, placeInfos["name"] as? String, placeInfos["address"] as? String , placeInfos["imageURL"] as? String)
            self?.panel.move(to: .tip, animated: true)
        }).disposed(by: nearbySearchController.disposeBag)
        
        
    }
}

//MARK: - User Current Location

extension SearchController: CLLocationManagerDelegate {
    
    private func setupUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        createSearchViewButtonCallbacks()
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
                        self?.searchView.navBarLocationButton.setTitle(placeName, for: .normal)
                    } else {
                        self?.searchView.navBarLocationButton.setTitle("Current location", for: .normal)
                    }
                }
            }
            removeAnnotations()
            addAnnotations(coordinates, annotationType: .userAnnotation)
            createFloatingPanel(coordinates)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
        print(error.localizedDescription)
    }
    
    
}

//MARK: - Annotations Management (CloseKeyboard, Remove Annotations, Add Annotations, Set Region )

extension SearchController {
    
    // Close Keyboard when finish SearchResultsController dismissed
    func closeKeyboard() {
        uiSearchController.searchResultsController?.dismiss(animated: true) { [weak self] in
            self?.uiSearchController.searchBar.resignFirstResponder()
        }
    }
    
    // Remove annotations when tap another Search Location
    func removeAnnotations(isNearbyPlace: Bool? = nil) {
        var annotations = searchView.mapView.annotations
        
        if let isNearbyPlace = isNearbyPlace {
            if isNearbyPlace {
                annotations.removeFirst()
                searchView.mapView.removeAnnotations(annotations)
            } else {
                searchView.mapView.removeAnnotations(annotations)
            }
        }
        
    }
    
    // Add annotation when tap Location
    func addAnnotations(_ coordinates: CLLocationCoordinate2D, annotationType: AnnotationType, _ title: String? = nil, _ subTitle: String? = nil, _ placeImage: String? = nil, _ profileImageURL: String? = nil) {
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        switch annotationType {
            
        case .userAnnotation:
            if let profileImageURL = self.profileImageURL {
                self.profileImageURL = profileImageURL
                pin.title = "You are here"
            }
        case .placeAnnotation:
            if let placeImage = placeImage {
                self.placeImage = placeImage
                if let title = title {
                    pin.title = title
                }
                if let subTitle = subTitle {
                    pin.subtitle = subTitle
                }
            }
        }
        
        searchView.mapView.addAnnotation(pin)
        
        setRegion(coordinates)
        
    }
    
    // Set region
    func setRegion(_ coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        searchView.mapView.setRegion(region, animated: true)
    }
    
}


//MARK: - Configure CustomAnnotationView

extension SearchController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var customAnnotationView = searchView.mapView.dequeueReusableAnnotationView(withIdentifier: "customAnnotationView") as? CustomAnnotationView
        
        
        if customAnnotationView == nil {
            // create one annotationView
            
            customAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotationView")
            customAnnotationView?.canShowCallout = true
        } else {
            customAnnotationView?.annotation = annotation
        }
        
        if let placeImage = self.placeImage {
            customAnnotationView?.imageView.downloadSetImage(type: .photoReference, url: placeImage)
            self.placeImage = nil
        }
        
        if let profileImageURL = profileImageURL {
            customAnnotationView?.imageView.downloadSetImage(type: .onlyURL, url: profileImageURL)
            self.profileImageURL = nil
        }
        
        return customAnnotationView
    }
}

//MARK: - SearchView AddSubview / Constraints

extension SearchController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(searchView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
        
    }
}

