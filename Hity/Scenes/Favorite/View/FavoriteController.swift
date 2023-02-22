//
//  FavoriteController.swift
//  Hity
//
//  Created by Ekrem Alkan on 7.02.2023.
//

import UIKit
import RxSwift
import MapKit

final class FavoriteController: UIViewController {

    
    //MARK: - Properties
    
    private let favoriteView = FavoriteView()
    private let favoriteViewModel = FavoriteViewModel()
    
    private let disposeBag = DisposeBag()

    //MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteViewModel.fetchFavoriteList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = favoriteView
        customizeNavBar()
        setupDelegates()
        createFavoriteCollectionViewCalllbacks()
    }
    
    private func setupDelegates() {
        favoriteView.favoriteCollectionView.delegate = self
    }
    
    private func customizeNavBar() {
        title = "Favorite Places"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Favorites", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }

    
    //MARK: - Creating FavoriteCollectionView callbacks
    
    private func createFavoriteCollectionViewCalllbacks() {
        
        //bind favorite places to collectionView

        favoriteViewModel.behaviorFavoriteList.bind(to: favoriteView.favoriteCollectionView.rx.items(cellIdentifier: FavoriteCell.identifier, cellType: FavoriteCell.self)) { row, favoritePlaces, cell in
            cell.configure(favoritePlaces)
            cell.favButton.isSelected = true
            cell.favButtonTap.subscribe(onNext: {
                if let placeUID = favoritePlaces.placeID {
                        let indexPath = self.favoriteViewModel.getProductIndexPath(placeUID: placeUID)
                        self.favoriteViewModel.removeProduct(index: row)
                        self.favoriteView.favoriteCollectionView.deleteItems(at: [indexPath])
                        self.favoriteViewModel.updateFirestoreFavoriteList(placeUID, false)
                    
                    cell.favButton.isSelected.toggle()
                }
            }).disposed(by: cell.disposeBag)
            
            cell.locationButtonTap.subscribe(onNext: {
                let lat = cell.location.latitude
                let lng = cell.location.longitude
                let mkMapItem = MKMapItem()
                if let placeName = cell.placeName.text {
                    mkMapItem.openMapForPlace(lat, lng, placeName)
                } else {
                    mkMapItem.openMapForPlace(lat, lng, "unkown")
                }

            }).disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        
        // fetch nearPlaces
        
        favoriteViewModel.isListUpdated.subscribe(onNext: { [weak self] _ in
            self?.favoriteViewModel.fetchFavoriteList()
        }).disposed(by: disposeBag)
        
        
        favoriteView.favoriteCollectionView.rx.modelSelected(DetailResults.self).bind(onNext: { [weak self] placeDetails in
            let controller = PlaceDetailController(place: placeDetails)
            self?.navigationController?.pushViewController(controller, animated: true)
            
        }).disposed(by: disposeBag)
        
    }



}

extension FavoriteController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (favoriteView.favoriteCollectionView.frame.width / 2) - 5, height: (favoriteView.favoriteCollectionView.frame.width / 1.25))
    }
}
