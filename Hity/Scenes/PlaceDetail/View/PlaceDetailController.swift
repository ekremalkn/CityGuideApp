//
//  PlaceDetailController.swift
//  Hity
//
//  Created by Ekrem Alkan on 5.02.2023.
//

import UIKit
import RxSwift
import CoreLocation
import MapKit

final class PlaceDetailController: UIViewController {
    
    //MARK: - Properties
    
    private let placeDetailView = PlaceDetailView()
    private let placeDetailViewModel = PlaceDetailViewModel()
    private let disposeBag = DisposeBag()
    var place: DetailResults
    
    
    //MARK: - Init Methods
    init(place: DetailResults) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle Methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let placeUID = place.placeID {
            placeDetailViewModel.fetchFavoriteListFromFirestore(placeUID)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = placeDetailView
        customizeNavBar()
        placeDetailView.configure(data: place)
        registerCollectionCell()
        setupDelegates()
        createPlaceDetailViewModelCallbacks()
        createFavButtonCallbakcs()
        createDetailViewButtonCallbacks()
        createInfoViewButtonCallbacks()
        placeDetailView.addressInfoButton.sendActions(for: .touchUpInside)
        createReviewsViewTableViewCallbacks()
        createPlaceNoReviewsCallback()
        createReviewsViewButtonCallbacks()
        
    }
    
    private func customizeNavBar() {
        title = "Place Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Detail", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func registerCollectionCell() {
        placeDetailView.imageCollectionView.register(PlaceDetailImageCell.self, forCellWithReuseIdentifier: PlaceDetailImageCell.identifier)
    }
    
    //MARK: - Setup Delegate

    private func setupDelegates() {
        placeDetailView.imageCollectionView.delegate = self
        placeDetailView.imageCollectionView.dataSource = self
        
    }

}

//MARK: - PlaceDetailViewModel Callbacks

extension PlaceDetailController {
    
    private func createPlaceDetailViewModelCallbacks() {
        placeDetailViewModel.isPlaceInFavoriteList.subscribe(onNext: { [weak self] value in
            if value {
                self?.placeDetailView.favButton.isSelected = true
            } else {
                self?.placeDetailView.favButton.isSelected = false
            }
        }).disposed(by: disposeBag)
    }
    
}

//MARK: - PlaceDetailView Buttons Callbacks

extension PlaceDetailController {
    
    private func createDetailViewButtonCallbacks() {
        placeDetailView.addressInfoButton.rx.tap.bind(onNext: { [unowned self] in
            
            self.placeDetailView.placeInfoView.configure(self.place)
            self.placeDetailView.toggleViews(self.placeDetailView.buttonBottomLine1)
        }).disposed(by: disposeBag)
        
        placeDetailView.openClosedInfoButton.rx.tap.bind(onNext: { [unowned self] in
            
            if let placeWeekdayText = self.place.currentOpeningHours?.weekdayText {
                self.placeDetailView.placeWeekdaysView.configure(placeWeekdayText)
            }
            self.placeDetailView.toggleViews(self.placeDetailView.buttonBottomLine2)
        }).disposed(by: disposeBag)
        
        placeDetailView.reviewsButton.rx.tap.bind(onNext: { [unowned self] in
            if let placeUID = place.placeID {
//                let controller = ReviewsController(placeUID: placeUID)
//                navigationController?.pushViewController(controller, animated: true)
                self.placeDetailViewModel.fetchPlaceReviews(placeUID)
            }
            self.placeDetailView.toggleViews(self.placeDetailView.buttonBottomLine3)
        }).disposed(by: disposeBag)
    }
    
    private func createFavButtonCallbakcs() {
        
        placeDetailView.favButton.rx.tap.bind(onNext: { [unowned self] in

            if self.placeDetailView.favButton.isSelected {
                if let placeUID = place.placeID {
                    placeDetailViewModel.updateFirestoreFavoriteList(placeUID, false)
                }
            } else {
                if let placeUID = place.placeID {
                    placeDetailViewModel.updateFirestoreFavoriteList(placeUID, true)
                }
                
            }
            
            self.placeDetailView.favButton.isSelected.toggle()
        }).disposed(by: disposeBag)
    }
}

//MARK: - Reviews TableView Callbacks

extension PlaceDetailController: UITableViewDelegate {
    
    private func createReviewsViewTableViewCallbacks() {
        
        //bind placereviews to tableview
        placeDetailViewModel.aPlaceReview.bind(to: placeDetailView.placeReviewsView.reviewsTableView.rx.items(cellIdentifier: ReviewsCell.identifier, cellType: ReviewsCell.self)) { [weak self] row, placeReviews, cell in
            cell.configure(placeReviews)
        }.disposed(by: disposeBag)
        
        //fetch placereviews
        if let placeUID = place.placeID {
            self.placeDetailViewModel.fetchPlaceReviews(placeUID)
        }
        
        // set tableview delegate for row height
        placeDetailView.placeReviewsView.reviewsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // set selection allows
        placeDetailView.placeReviewsView.reviewsTableView.rx.allowsSelection.onNext(false)
        
        // set scroll allows
        placeDetailView.placeReviewsView.reviewsTableView.rx.isScrollEnabled.onNext(false)
    }
    
    func createPlaceNoReviewsCallback() {
        placeDetailViewModel.noReviews.subscribe { [weak self] noReviews in
            if noReviews {
                self?.placeDetailView.placeReviewsView.showMoreButton.isHidden = true
                self?.placeDetailView.placeReviewsView.noReviewsLabel.isHidden = false
            }
        }.disposed(by: disposeBag)
    }
    
    // TableView Delegate Rowheight
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
}

//MARK: - PlaceReviewsView Buttons Callbacks

extension PlaceDetailController {
    
    private func createReviewsViewButtonCallbacks() {
        let placeReviewsView = placeDetailView.placeReviewsView
        
        placeReviewsView.showMoreButton.rx.tap.bind(onNext: { [weak self] in
            if let placeUID = self?.place.placeID {
                let controller = ReviewsController(placeUID: placeUID)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            
        }).disposed(by: disposeBag)
    }
}


//MARK: - PlaceInfoView Buttons Callbacks

extension PlaceDetailController {
    
    private func createInfoViewButtonCallbacks() {
        let placeInfoView = placeDetailView.placeInfoView
        placeInfoView.address.rx.tap.bind(onNext: { [weak self] in
            
            if let lat = self?.place.geometry?.location?.lat, let lng = self?.place.geometry?.location?.lng {
                let mkMapItem = MKMapItem()
                if let placeName = self?.place.name {
                    mkMapItem.openMapForPlace(lat, lng, placeName)
                } else {
                    mkMapItem.openMapForPlace(lat, lng, "unknown")
                }
            }
        }).disposed(by: disposeBag)
        
        placeInfoView.openingHours.rx.tap.bind(onNext: { [unowned self] in
            
            let placeWeekdayText = self.place.currentOpeningHours?.weekdayText
                self.placeDetailView.placeWeekdaysView.configure(placeWeekdayText)
            
            self.placeDetailView.toggleViews(self.placeDetailView.buttonBottomLine2)

        }).disposed(by: disposeBag)
        
        if let websiteLabel = placeInfoView.website.titleLabel {
            placeInfoView.website.rx.tap.bind(with: websiteLabel, onNext: {websiteURL,_ in
                
                guard let url = websiteLabel.text else { return }
                guard let URL = URL(string: url) else { return }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL)
                }
            }).disposed(by: disposeBag)
        }
        
        // this can work only real device not simulator
        if let phoneNumberLabel = placeInfoView.phoneNumber.titleLabel {
            placeInfoView.phoneNumber.rx.tap.bind(with: phoneNumberLabel, onNext: { phoneNumber, _ in
                guard let phoneNumber = phoneNumberLabel.text else { return }
                guard let number = URL(string: "tel://" + phoneNumber) else { return }
                UIApplication.shared.open(number)
            }).disposed(by: disposeBag)
        }
        
        
    }

}



//MARK: - CollectionView Methods

extension PlaceDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let placePhotoCount = place.photos?.count {
            return placePhotoCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = placeDetailView.imageCollectionView.dequeueReusableCell(withReuseIdentifier: PlaceDetailImageCell.identifier, for: indexPath) as? PlaceDetailImageCell else { return UICollectionViewCell()}
        if let placePhotos = place.photos?[indexPath.row] {
            cell.configure(placePhotos, place)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: placeDetailView.imageCollectionView.frame.width, height: placeDetailView.imageCollectionView.frame.height)
    }
    
}

extension PlaceDetailController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let width = scrollView.frame.width
        placeDetailView.currentPage = Int(contentOffset) / Int(width)
    }

}

