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
    
    private let manager = GooglePlacesManager.shared
    
    var places = PublishSubject<[PlacesModel]>()
    var coordinate = PublishSubject<CLLocationCoordinate2D>()
    
    func fetchPlaces(_ query: String) {
        
        manager.findPlaces(query: query) { [weak self] places in
            if let places = places {
                self?.places.onNext(places)
            }
        } onError: { [weak self] error in
            self?.places.onError(error)
        }
        
    }
    
    func fetchCoordianates(_ placeUID: String) {
        
        manager.fetchCoordinates(placeUID: placeUID) { [weak self] coordinate in
            if let coordinate = coordinate {
                self?.coordinate.onNext(coordinate)
            }
        } onError: { [weak self] error in
            self?.coordinate.onError(error)
        }
        
    }
}
