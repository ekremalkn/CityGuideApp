//
//  NearbySearchController.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import UIKit
import RxSwift
import CoreLocation


final class NearbySearchController: UIViewController {
    
    //MARK: - PopUp View Controllers
    
    let distancePopUpController = DistancePopUpController()
    let sortPopUpController = SortPopUpController()
    
    //MARK: - Constants
    private let nearBySearchView = NearbySearchView()
    private let nearBySearchViewModel = NearbySearchViewModel()
    
    //MARK: - Observable Variables
    
    var didTapNearbyCellLocationButton = PublishSubject<[String: Any]>()
    
    //MARK: - Dispose Bag
    
    private (set) var disposeBag = DisposeBag()
    
    //MARK: - Variables
    
    // init variables
    var lat: Double
    var lng: Double
    
    // search location for calculate distance between search location and nearby place location
    var mainLocation: CLLocation?
    
    // filter, sort variables
    var searchDistance: String = "1000"
    var sortType: SortTypesTitle?
    
    //MARK: - Init Methods
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        self.mainLocation = CLLocation(latitude: lat, longitude: lng)
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
        view = nearBySearchView
        createCallbacks()
        configureCollectionView()
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        createNearbySearchViewModelCallbacks()
        createSearchDistanceButtonCallbacks()
        createSortButtonCallbacks()
    }
    
    //MARK: - Search Distance / Sort button callbacks
    
    private func createSearchDistanceButtonCallbacks() {
        
        // Search Distance Button
        nearBySearchView.searchDistanceButton.rx.tap.bind(onNext: { [unowned self] in
            self.distancePopUpController.presentPopUpController(self)
            
        }).disposed(by: disposeBag)
        
        // Set Distance Button
        distancePopUpController.whenTapSetButtonDistance.subscribe { [weak self] distance in
            self?.searchDistance = distance
            self?.nearBySearchView.searchDistanceButton.setTitle("about in: \(distance)m", for: .normal)
            self?.nearBySearchViewModel.fetchNearPlaces(self?.nearBySearchView.textField.text ?? "", self!.lat, self!.lng, searchDistance: distance, sortType: self?.sortType ?? .logic)
        }.disposed(by: distancePopUpController.disposeBag)
        
    }
    
    private func createSortButtonCallbacks() {
        
        // Sort Button
        nearBySearchView.textField.sortButton.rx.tap.bind(onNext: { [unowned self] in
            self.sortPopUpController.presentPopUpController(self)
            
        }).disposed(by: disposeBag)
        
        // TableView Cell selected
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
    
    //MARK: - Create NearbySearchViewModel Callbacks
    
    private func createNearbySearchViewModelCallbacks() {
        
        nearBySearchViewModel.placeDetails.subscribe(onNext: { [weak self] placeDetails in
            let controller = PlaceDetailController(place: placeDetails)
            self?.navigationController?.pushViewController(controller, animated: true)
            
        }).disposed(by: disposeBag)
    }
    
    
    //MARK: - Configure CollectionView
    
    private func configureCollectionView() {
        
        //bind near places to collectionView
        
        nearBySearchViewModel.nearPlaces.bind(to: nearBySearchView.collectionView.rx.items(cellIdentifier: NearbyPlacesCell.identifier, cellType: NearbyPlacesCell.self)) { [weak self] row, nearPlaces, cell in
            if let mainLocation = self?.mainLocation {
                cell.configure(nearPlaces, mainLocation)
            } else {
                cell.configure(nearPlaces)
            }
            
            // Cell Info Button
            cell.didTapInfoButton.subscribe(onNext: {
                print("ifno")
                self?.nearBySearchViewModel.fetchPlaceDetails(cell.placeInfos?["uid"] as! String)
            }).disposed(by: cell.disposeBag)
            
            // Cell Location Button
            cell.didTapLocationButton.subscribe(onNext: {
                print("dokunuldu")
                self?.didTapNearbyCellLocationButton.onNext(cell.placeInfos ?? [:])
            }).disposed(by: cell.disposeBag)
            
            
            // Cell Fav Button
            cell.didTapFavButton.subscribe(onNext: {
                if cell.favButton.isSelected {
                    self?.nearBySearchViewModel.updateFirestoreFavoriteList((cell.placeInfos?["uid"] as! String), false)
                } else {
                    self?.nearBySearchViewModel.updateFirestoreFavoriteList((cell.placeInfos?["uid"] as! String ), true)
                }
                
                cell.favButton.isSelected.toggle()
            }).disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        
        // Fetch Near Places when change text in textfield
        ////Throttle ile birlikte kullanıcı arama yaparken textfield'in texi her değiştiğinde bu fonksiyon çalışacağı için google places'a birçok istek atmayı önlüyorum.
        nearBySearchView.textField.rx.text.throttle(.seconds(2), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] text in
            if let text = text, !text.isEmpty  {
                if let lat = self?.lat, let lng = self?.lng {
                    self?.nearBySearchViewModel.fetchNearPlaces(text, lat, lng, searchDistance: self?.searchDistance ?? "", sortType: .logic)
                }
            } else {
                self?.nearBySearchViewModel.fetchNearPlaces("", self!.lat, self!.lng, searchDistance: self?.searchDistance ?? "1000", sortType: .logic)
            }
        }).disposed(by: nearBySearchView.disposeBag)
        
        // Set delegeate for collectionview size
        nearBySearchView.collectionView.rx.setDelegate(self).disposed(by: nearBySearchView.disposeBag)
        
    }
    
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension NearbySearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (nearBySearchView.collectionView.frame.width / 2) - 10 , height: (nearBySearchView.collectionView.frame.width) * 0.85)
    }
}











