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
        nearBySearchView.collectionView.delegate = self
        view.backgroundColor = .systemBackground
        view = nearBySearchView
        reactiveTextField()
        configureCollectionView()
        didFetchPlaceDetails()
    }
    
    //MARK: - Reactive Collection View

    
    private func configureCollectionView() {
        
        //bind near places to tableview
        
        nearBySearchViewModel.nearPlaces.bind(to: nearBySearchView.collectionView.rx.items(cellIdentifier: "NearbyPlacesCell", cellType: NearbyPlacesCell.self)) {row, nearPlaces, cell in
            
            cell.configure(nearPlaces)
            cell.showDetailsButton.rx.tap.subscribe(onNext: { _ in
                if let placeUID = cell.placeUID {
                    print("alkan")
                    self.nearBySearchViewModel.fetchPlaceDetails(placeUID)

                }

            }).disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
        

        // fetch nearPlaces
        
        searchText.subscribe(onNext: { [weak self] text in
            if let lat = self?.lat, let lng = self?.lng {
                self?.nearBySearchViewModel.fetchNearPlaces(text, lat, lng)
            }
            
        }).disposed(by: disposeBag)
        
        // handle didselect

        nearBySearchView.collectionView.rx.modelSelected(Result.self).bind(onNext: { [weak self] place in
            if let lat = place.geometry?.location?.lat, let lng = place.geometry?.location?.lng, let name = place.name, let address = place.vicinity {
                let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                self?.delegate?.didTapNearLocation(coordinates, name, address)
            }
            
        }).disposed(by: disposeBag)
        
        
    }
    
}

//MARK: - DidFetch placeDetails

extension NearbySearchController {
    
    func didFetchPlaceDetails() {
        nearBySearchViewModel.placeDetails.subscribe(onNext: { [weak self] placeDetails in
            print("ekrem")
            let controller = PlaceDetailController(place: placeDetails)
            self?.show(controller, sender: nil)
        }).disposed(by: disposeBag)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension NearbySearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (nearBySearchView.collectionView.frame.width / 2) - 10, height: nearBySearchView.collectionView.frame.width)
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




