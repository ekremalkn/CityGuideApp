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
    
    //MARK: - Constants
    
    private let placeDetailView = PlaceDetailView()
    private let placeDetailViewModel = PlaceDetailViewModel()
    
    //MARK: - Observable Variables
    
    let imageCollectionViewImages = PublishSubject<[DetailPhoto]>()
    
    //MARK: - Dispose Bag
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Init Variable
    
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
        // checking every viewapper is place in favorite list
        if let placeUID = place.placeID {
            placeDetailViewModel.fetchFavoriteListFromFirestore(placeUID)
        }
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = placeDetailView
        customizeNavBar()
        registerCollectionCell()
        createCallbacks()
        detailViewConfigure()
        placeDetailView.infoButton.sendActions(for: .touchUpInside)
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
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        configureImageCollectionView()
        createPlaceDetailViewModelCallbacks()
        createFavButtonCallbakcs()
        createDetailViewButtonCallbacks()
        createInfoViewButtonCallbacks()
        createReviewsViewTableViewCallbacks()
        createPlaceNoReviewsCallback()
        createReviewsViewButtonCallbacks()
    }
    
    //MARK: - Configure DetailView
    
    private func detailViewConfigure() {
        placeDetailView.configure(place)
        if let placePhotos = place.photos {
            self.imageCollectionViewImages.onNext(placePhotos)
        }
    }
    
}

//MARK: - PlaceDetailViewModel Callbacks

extension PlaceDetailController {
    
    private func createPlaceDetailViewModelCallbacks() {
        
        // if place in favorite list
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
        
        // Info Button
        placeDetailView.infoButton.rx.tap.bind(onNext: { [unowned self] in
            
            self.placeDetailView.placeInfoView.configure(self.place)
            self.placeDetailView.toggleViews(self.placeDetailView.buttonBottomLine1)
        }).disposed(by: disposeBag)
        
        // Open / Closed Info Button
        placeDetailView.weekdayButton.rx.tap.bind(onNext: { [unowned self] in
            
            if let placeWeekdayText = self.place.currentOpeningHours?.weekdayText {
                self.placeDetailView.placeWeekdaysView.configure(placeWeekdayText)
            }
            self.placeDetailView.toggleViews(self.placeDetailView.buttonBottomLine2)
        }).disposed(by: disposeBag)
        
        // Reviews Button
        placeDetailView.reviewsButton.rx.tap.bind(onNext: { [unowned self] in
            if let placeUID = place.placeID {
                self.placeDetailViewModel.fetchPlaceReviews(placeUID)
            }
            self.placeDetailView.toggleViews(self.placeDetailView.buttonBottomLine3)
        }).disposed(by: disposeBag)
    }
    
    private func createFavButtonCallbakcs() {
        
        // Fav Button
        placeDetailView.favButton.rx.tap.bind(onNext: { [unowned self] in
            
            if self.placeDetailView.favButton.isSelected {
                if let placeUID = place.placeID {
                    // delete from favorite list
                    placeDetailViewModel.updateFirestoreFavoriteList(placeUID, false)
                }
            } else {
                // add to favorite list
                if let placeUID = place.placeID {
                    placeDetailViewModel.updateFirestoreFavoriteList(placeUID, true)
                }
            }
            self.placeDetailView.favButton.isSelected.toggle()
        }).disposed(by: disposeBag)
    }
}

//MARK: - ReviewsView TableView Callbacks

extension PlaceDetailController: UITableViewDelegate {
    
    private func createReviewsViewTableViewCallbacks() {
        
        //bind placereviews to tableview
        placeDetailViewModel.aPlaceReview.bind(to: placeDetailView.placeReviewsView.reviewsTableView.rx.items(cellIdentifier: ReviewsCell.identifier, cellType: ReviewsCell.self)) { row, placeReviews, cell in
            cell.configure(placeReviews)
        }.disposed(by: disposeBag)
        
        //fetch placereviews
        if let placeUID = place.placeID {
            self.placeDetailViewModel.fetchPlaceReviews(placeUID)
        }
        
        // set tableview delegate for row height
        placeDetailView.placeReviewsView.reviewsTableView.rx.setDelegate(self).disposed(by: placeDetailView.placeReviewsView.disposeBag)
        
        // set selection allows
        placeDetailView.placeReviewsView.reviewsTableView.rx.allowsSelection.onNext(false)
        
        // set scroll allows
        placeDetailView.placeReviewsView.reviewsTableView.rx.isScrollEnabled.onNext(false)
    }
    
    func createPlaceNoReviewsCallback() {
        
        // if place does not have any reviews
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
        
        // Show More Button
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
        
        // Address Line Callback
        placeInfoView.address.rx.tap.bind(onNext: { [weak self] in
            
            // will show location on apple maps
            if let lat = self?.place.geometry?.location?.lat, let lng = self?.place.geometry?.location?.lng {
                let mkMapItem = MKMapItem()
                if let placeName = self?.place.name {
                    mkMapItem.openMapForPlace(lat, lng, placeName)
                } else {
                    mkMapItem.openMapForPlace(lat, lng, "unknown")
                }
            }
        }).disposed(by: disposeBag)
        
        // Open / Closed Line Callback
        placeInfoView.openingHours.rx.tap.bind(onNext: { [unowned self] in
            
            // will show weekday view
            let placeWeekdayText = self.place.currentOpeningHours?.weekdayText
            self.placeDetailView.placeWeekdaysView.configure(placeWeekdayText)
            self.placeDetailView.toggleViews(self.placeDetailView.buttonBottomLine2)
            
        }).disposed(by: disposeBag)
        
        // Website Line Callback
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
        
        // PhoneNumber Line Callback (this can work only real device not simulator)
        if let phoneNumberLabel = placeInfoView.phoneNumber.titleLabel {
            placeInfoView.phoneNumber.rx.tap.bind(with: phoneNumberLabel, onNext: { phoneNumber, _ in
                guard let phoneNumber = phoneNumberLabel.text else { return }
                guard let number = URL(string: "tel://" + phoneNumber) else { return }
                UIApplication.shared.open(number)
            }).disposed(by: disposeBag)
        }
        
        
    }
    
}



//MARK: - Configure ImageCollectionView

extension PlaceDetailController {
    
    //MARK: - Configure ImageCollectionView
    
    private func configureImageCollectionView() {
        
        // bind photos to imagecollectionview
        
        imageCollectionViewImages.bind(to: placeDetailView.imageCollectionView.rx.items(cellIdentifier: PlaceDetailImageCell.identifier, cellType: PlaceDetailImageCell.self)) {[unowned self] row, placePhoto, cell in
            cell.configurePhotos(placePhoto)
            cell.configureRatings(place)
        }.disposed(by: placeDetailView.disposeBag)
        
        // set delegate for cell size
        placeDetailView.imageCollectionView.rx.setDelegate(self).disposed(by: placeDetailView.disposeBag)
        
    }
    
    
    
}

//MARK: - Handle Image Swipe fit

extension PlaceDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: placeDetailView.imageCollectionView.frame.width, height: placeDetailView.imageCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let width = scrollView.frame.width
        placeDetailView.currentPage = Int(contentOffset) / Int(width)
    }
    
}

