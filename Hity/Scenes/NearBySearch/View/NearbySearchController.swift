//
//  NearbySearchController.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import UIKit
import RxSwift
import CoreLocation

protocol NearbySearchControllerDelegate: AnyObject {
    func didTapNearLocation(_ coordinates: CLLocationCoordinate2D, _ pinTitle: String, _ pinSubTitle: String)
}

final class NearbySearchController: UIViewController {
    
    
    //MARK: - Properties
    weak var delegate: NearbySearchControllerDelegate?
    private let nearBySearchView = NearbySearchView()
    private let nearBySearchViewModel = NearbySearchViewModel()
    
    var searchText = PublishSubject<String>()
    var lat: Double
    var lng: Double
    var mainLocation: CLLocation?
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Init Methods

    init(lat: Double, lng: Double) {
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
        nearBySearchView.collectionView.delegate = self
        
        view.backgroundColor = .systemBackground
        view = nearBySearchView
        reactiveTextField()
        configureCollectionView()
        didFetchPlaceDetails()
        createMainLocation()
    }
    
    //MARK: - Make base location to CLLocation

    private func createMainLocation() {
        self.mainLocation = CLLocation(latitude: lat, longitude: lng)
    }
    
    //MARK: - Reactive Collection View

    
    private func configureCollectionView() {
        
        //bind near places to tableview
        
        nearBySearchViewModel.nearPlaces.bind(to: nearBySearchView.collectionView.rx.items(cellIdentifier: NearbyPlacesCell.identifier, cellType: NearbyPlacesCell.self)) { [weak self] row, nearPlaces, cell in
            cell.interace = self
            if let mainLocation = self?.mainLocation {
                cell.configure(nearPlaces, mainLocation)
            } else {
                cell.configure(nearPlaces)
            }

        }.disposed(by: disposeBag)
        

        // fetch nearPlaces
        
        searchText.subscribe(onNext: { [weak self] text in
            if let lat = self?.lat, let lng = self?.lng {
                self?.nearBySearchViewModel.fetchNearPlaces(text, lat, lng)
            }
            
        }).disposed(by: disposeBag)
        
        // handle didselect

        nearBySearchView.collectionView.rx.modelSelected(Result.self).bind(onNext: { [weak self] place in
//            if let lat = place.geometry?.location?.lat, let lng = place.geometry?.location?.lng, let name = place.name, let address = place.vicinity {
//                let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                self?.delegate?.didTapNearLocation(coordinates, name, address)
//            }
            
        }).disposed(by: disposeBag)
        
        
    }

    
}

//MARK: - NearbyPlacesCellInterface, didFetchPlaceDetails, didFetchCoordinates

extension NearbySearchController: NearbyPlacesCellInterface {
  
    func didTapDetailsButton(_ view: NearbyPlacesCell, _ placeUID: String) {
        nearBySearchViewModel.fetchPlaceDetails(placeUID)
    }
    
    func didFetchPlaceDetails() {
        nearBySearchViewModel.placeDetails.subscribe(onNext: { [weak self] placeDetails in
            let controller = PlaceDetailController(place: placeDetails)
            self?.show(controller, sender: nil)
        }).disposed(by: disposeBag)
    }

    func didTapLocationButton(_ view: NearbyPlacesCell, _ coordinates: CLLocationCoordinate2D, _ placeName: String) {
        self.delegate?.didTapNearLocation(coordinates, placeName, "")
    }
    
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension NearbySearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (nearBySearchView.collectionView.frame.width / 2) - 10 , height: (nearBySearchView.collectionView.frame.width / 1.25))
    }
}


//MARK: - Reactive TextField

extension NearbySearchController {
    
    func reactiveTextField() {
        //Throttle ile birlikte kullanıcı arama yaparken textfield'in texi her değiştiğinde bu fonksiyon çalışacağı için google places'a birçok istek atmayı önlüyorum.
        nearBySearchView.textField.rx.text.throttle(.seconds(2), scheduler: MainScheduler.instance).bind(onNext: { [weak self] text in
            if let text = text, !text.isEmpty {
             
                
                self?.searchText.onNext(text)
            }
        }).disposed(by: disposeBag)
        
    }
}

    
    
   





