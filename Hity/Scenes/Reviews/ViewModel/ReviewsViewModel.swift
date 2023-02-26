//
//  ReviewsViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import RxSwift


final class ReviewsViewModel {
    
    //MARK: - Constants
    
    private let webServiceManager = Service.shared
    
    
    //MARK: - Observable Variables
    
    var placeReviews = PublishSubject<[DetailReview]>()
    
    //MARK: - Fetch Place Revies
    
    func fetchPlaceReviews(_ placeUID: String, sortType: ReviewsSortTypesTitle) {
        
        webServiceManager.placeDetail(placeUID: placeUID) { [weak self] place in
            if let placeReviews = place?.result?.reviews {
                switch sortType {
                case .logic:
                    self?.placeReviews.onNext(placeReviews)
                case .maxToMinRating:
                    let ratingSortedPlaces = placeReviews.sorted {
                        $0.rating ?? 0 > $1.rating ?? 0
                    }
                    self?.placeReviews.onNext(ratingSortedPlaces)
                case .newestToOldest:
                    let timeSortedPlaces = placeReviews.sorted {
                        $0.reviewTime > $1.reviewTime } // closest review
                    self?.placeReviews.onNext(timeSortedPlaces)
                    
                    }
                
                
                
            }
        } onError: { [weak self] error in
            self?.placeReviews.onError(error)
        }
        
        
    }
}
