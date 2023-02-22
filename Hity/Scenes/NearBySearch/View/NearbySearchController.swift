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
    
    init(lat: Double, lng: Double, sortType: Observable<[SortType]>) {
        self.lat = lat
        self.lng = lng
        self.observableSort = sortType
        super.init(nibName: nil, bundle: nil)
    }
    
    var searchDistance: String? = "1000"
    
    var observableDistance: Observable<[String]> = Observable.of([
        "100",
        "200",
        "300",
        "400",
        "500",
        "1000",
        "1500",
        "2000"
    ])
    
    var sortType: SortType?
    var observableSort: Observable<[SortType]>
    
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
        
        view.backgroundColor = .systemBackground
        view = nearBySearchView
        reactiveTextField()
        configureCollectionView()
        didFetchPlaceDetails()
        createMainLocation()
        createSearchDistanceButtonCallbacks()
        createSearchDistancePickerViewCallbacks()
        createSortButtonCallbacks()
        createSortPickerViewCallbacks()
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
                    cell.favButton.isSelected.toggle()
                }
                
            }).disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        
        // fetch nearPlaces
        
        nearBySearchView.textField.rx.text.subscribe(onNext: { [weak self] text in
            if let text = text {
                if let lat = self?.lat, let lng = self?.lng {
                    if let searchDistance = self?.searchDistance {
                    
                        self?.nearBySearchViewModel.fetchNearPlaces(text, lat, lng, searchDistance: searchDistance, sortType: .smart)
                        
                    }
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


//MARK: - SearchDistanceButton callbacks

extension NearbySearchController {
    
    private func createSearchDistanceButtonCallbacks() {
        
        nearBySearchView.searchDistanceButton.rx.tap.bind(onNext: { [unowned self] in
            let controller = UIViewController()
            self.present(controller.createDistancePopUpPickerView(self.nearBySearchView.searchDistancePickerView, self.nearBySearchView.searchDistanceButton, self.observableDistance), animated: true)
            
        }).disposed(by: disposeBag)
        
    }
    
    private func createSortButtonCallbacks() {
        nearBySearchView.textField.sortButton.rx.tap.bind(onNext: { [unowned self] in
            let controller = UIViewController()
            self.present(controller.createSortPopUpPickerView(self.nearBySearchView.sortPickerView, self.nearBySearchView.textField.sortButton, observableSort: observableSort), animated: true)
            
        }).disposed(by: disposeBag)
    }
}

//MARK: - Creating PickerView Callbakcs

extension NearbySearchController {
    
    private func createSearchDistancePickerViewCallbacks() {
        
        // bind distance meters to pickerview
        observableDistance.bind(to: nearBySearchView.searchDistancePickerView.rx.itemTitles) { row, element in
            return element
        }.disposed(by: disposeBag)
        
        // handle selected
        
        nearBySearchView.searchDistancePickerView.rx.itemSelected.subscribe { [unowned self] event in
            switch event {
                
            case .next((let row, _)):
                self.observableDistance.subscribe { distances in
                    self.searchDistance = distances[row]
                    self.nearBySearchViewModel.fetchNearPlaces(self.nearBySearchView.textField.text ?? "", self.lat, self.lng, searchDistance: distances[row], sortType: self.sortType ?? .smart )
                }.disposed(by: self.disposeBag)
            default:
                break
                
            }
        }.disposed(by: disposeBag)
    }
    
    private func createSortPickerViewCallbacks() {
        
        // bind sort type to pickerview

        observableSort.bind(to: nearBySearchView.sortPickerView.rx.itemTitles) {row, element in
            return element.rawValue
        }.disposed(by: disposeBag)
        
        
        // handle selected
        
        nearBySearchView.sortPickerView.rx.itemSelected.subscribe { [unowned self] event in
            switch event {
                
            case .next((let row, _)):
                self.observableSort.subscribe(onNext: { sortType in
                    self.sortType = sortType[row]
                    self.nearBySearchViewModel.fetchNearPlaces(self.nearBySearchView.textField.text ?? "", self.lat, self.lng, searchDistance: self.searchDistance ?? "1000", sortType: sortType[row])
                    
                }).disposed(by: disposeBag)
            default:
                break
            }
            
        }.disposed(by: disposeBag)
    }
    
}










