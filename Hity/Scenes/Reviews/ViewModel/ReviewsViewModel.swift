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

    func fetchPlaceReviews(_ placeUID: String) {
        
        webServiceManager.placeDetail(placeUID: placeUID) { [weak self] place in
            if let placeReviews = place?.result?.reviews {
                self?.placeReviews.onNext(placeReviews)
            }
        } onError: { [weak self] error in
            self?.placeReviews.onError(error)
        }


    }
}
