//
//  SearchViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import Foundation
import RxSwift
import CoreLocation

final class SearchViewModel {
    
    private let googlePlacesManager = GooglePlacesManager.shared
    
    var places = PublishSubject<[PlacesModel]>()
    var coordinates = PublishSubject<CLLocationCoordinate2D>()
    
    func fetchPlaces(_ query: String) {
        
        googlePlacesManager.findPlaces(query: query) { [weak self] places in
            if let places = places {
                self?.places.onNext(places)
            }
        } onError: { [weak self] error in
            self?.places.onError(error)
        }
        
    }
    
    func fetchCoordinates(_ placeUID: String) {
        
        googlePlacesManager.fetchCoordinates(placeUID: placeUID) { [weak self] coordinate in
            if let coordinate = coordinate {
                self?.coordinates.onNext(coordinate)
            }
        } onError: { [weak self] error in
            self?.coordinates.onError(error)
        }
        
    }
    


 

}
