//
//  SearchViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import Foundation
import RxSwift

final class SearchViewModel {
    
    private let manager = GooglePlacesManager.shared
    
    var places = PublishSubject<[PlacesModel]>()
    
    func fetchPlaces(_ query: String) {
        
        manager.findPlaces(query: query) { places in
            if let places = places {
                self.places.onNext(places)
            }
        } onError: { error in
            self.places.onError(error)
        }

    }
}
