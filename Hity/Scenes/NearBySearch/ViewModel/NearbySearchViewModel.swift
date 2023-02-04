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
    
    func fetchNearPlaces(_ input: String, _ lat: String, _ lng: String) {
        
        webServiceManager.nearyBySearch(input: input, lat: lat, lng: lng) { [weak self] nearPlaces in
            if let nearPlaces = nearPlaces?.results {
                self?.nearPlaces.onNext(nearPlaces)
            }
        } onError: { error in
            self.nearPlaces.onError(error)
        }

    }
}
