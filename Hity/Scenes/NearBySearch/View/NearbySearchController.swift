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
    func didTapNearLocation(_ coordinates: CLLocationCoordinate2D, _ pinTitle: String, _ pinSubTitle: String, _ placeImage: String)
}

final class NearbySearchController: UIViewController {
    
    //MARK: - View Controllers
    
    let distancePopUpController = DistancePopUpController()
    let sortPopUpController = SortPopUpController()
    
    //MARK: - Properties
    weak var delegate: NearbySearchControllerDelegate?
    private let nearBySearchView = NearbySearchView()
    private let nearBySearchViewModel = NearbySearchViewModel()
    
    var searchText = PublishSubject<String>()
    var lat: Double
    var lng: Double
    var mainLocation: CLLocation?
    private let disposeBag = DisposeBag()
    var searchDistance: String = "1000"
    var sortType: SortTypesTitle?
    //MARK: - Init Methods
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        super.init(nibName: nil, bundle: nil)
    }
        
    var selectedRow = 0
    
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
        view = nearBySearchView
        reactiveTextField()
        configureCollectionView()
        didFetchPlaceDetails()
        createMainLocation()
        createSearchDistanceButtonCallbacks()
        createSortButtonCallbacks()
    }
    
    //MARK: - Make base location to CLLocation
    
    private func createMainLocation() {
        self.mainLocation = CLLocation(latitude: lat, longitude: lng)
    }
    
    //MARK: - Reactive Collection View
    
    
    private func configureCollectionView() {
        
        //bind near places to collectionView
        
        nearBySearchViewModel.nearPlaces.bind(to: nearBySearchView.collectionView.rx.items(cellIdentifier: NearbyPlacesCell.identifier, cellType: NearbyPlacesCell.self)) { [weak self] row, nearPlaces, cell in
            cell.interace = self
            if let mainLocation = self?.mainLocation {
                cell.configure(nearPlaces, mainLocation)
            } else {
                cell.configure(nearPlaces)
            }
            
            cell.favButtonTap.subscribe(onNext: {
                if let placeUID = cell.placeUID {
                    if cell.favButton.isSelected {
                        self?.nearBySearchViewModel.updateFirestoreFavoriteList(placeUID, false)
                    } else {
                        self?.nearBySearchViewModel.updateFirestoreFavoriteList(placeUID, true)
                    }
                }
                cell.favButton.isSelected.toggle()
            }).disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        
        // fetch nearPlaces
        
        nearBySearchView.textField.rx.text.subscribe(onNext: { [weak self] text in
            if let text = text {
                if let lat = self?.lat, let lng = self?.lng {
                    
                    self?.nearBySearchViewModel.fetchNearPlaces(text, lat, lng, searchDistance: self?.searchDistance ?? "", sortType: .logic)
                        
                    
                }
            }
            
            
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
            self?.navigationController?.pushViewController(controller, animated: true)
            //            self?.show(controller, sender: nil)
        }).disposed(by: disposeBag)
    }
    
    func didTapLocationButton(_ view: NearbyPlacesCell, _ coordinates: CLLocationCoordinate2D, _ placeName: String, _ placeImage: String) {
        self.delegate?.didTapNearLocation(coordinates, placeName, "", placeImage)
    }
    
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension NearbySearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (nearBySearchView.collectionView.frame.width / 2) - 10 , height: (nearBySearchView.collectionView.frame.width))
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


//MARK: - Search Distance / Sort button callbacks

extension NearbySearchController {
    
    private func createSearchDistanceButtonCallbacks() {
        
        nearBySearchView.searchDistanceButton.rx.tap.bind(onNext: { [unowned self] in
            self.distancePopUpController.presentPopUpController(self)
            
        }).disposed(by: disposeBag)
        
        
        distancePopUpController.whenTapSetButtonDistance.subscribe { [weak self] distance in
            self?.searchDistance = distance
            self?.nearBySearchView.searchDistanceButton.setTitle("about in: \(distance)m", for: .normal)
            self?.nearBySearchViewModel.fetchNearPlaces(self?.nearBySearchView.textField.text ?? "", self!.lat, self!.lng, searchDistance: distance, sortType: self?.sortType ?? .logic)
        }.disposed(by: disposeBag)
        
    }
    
    private func createSortButtonCallbacks() {
        nearBySearchView.textField.sortButton.rx.tap.bind(onNext: { [unowned self] in
            self.sortPopUpController.presentPopUpController(self)
            
        }).disposed(by: disposeBag)
        
        
        self.sortPopUpController.tableViewCellSelected.subscribe { [weak self] sortTypeTitle in
            switch sortTypeTitle {
                
            case .next(let sortType):
                self?.sortType = sortType
                self?.nearBySearchViewModel.fetchNearPlaces(self?.nearBySearchView.textField.text ?? "", self!.lat, self!.lng, searchDistance: "1000", sortType: sortType )
            default:
                break
            }
        }.disposed(by: sortPopUpController.disposeBag)
    }
    

}










