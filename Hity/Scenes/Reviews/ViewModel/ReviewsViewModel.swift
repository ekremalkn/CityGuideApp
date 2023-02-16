//
//  ReviewsViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import RxSwift


final class ReviewsViewModel {
    
    private let webServiceManager = Service.shared
    
    var placeReviews = PublishSubject<[DetailReview]>()
    
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
