//
//  NearbySearchViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import Foundation
import RxSwift


final class NearbySearchViewModel {
    
    private let webServiceManager = Service.shared
    
    var nearPlaces = PublishSubject<[Result]>()
    var placeDetails = PublishSubject<DetailResults>()

    
    func fetchNearPlaces(_ input: String, _ lat: Double, _ lng: Double) {

        webServiceManager.nearyBySearch(input: input, lat: lat, lng: lng) { [weak self] nearPlaces in
            if let nearPlaces = nearPlaces?.results {
                self?.nearPlaces.onNext(nearPlaces)
            }
        } onError: { error in
            self.nearPlaces.onError(error)
        }

    }
    
        func fetchPlaceDetails(_ placeUID: String) {
    
            webServiceManager.placeDetail(placeUID: placeUID) { [weak self] place in
                if let placeDetails = place?.result {
                    self?.placeDetails.onNext(placeDetails)
                }
            } onError: { [weak self] error in
                self?.placeDetails.onError(error)
            }
    
    
    
        }
}
