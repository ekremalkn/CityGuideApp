//
//  SearchResultViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import RxSwift
import CoreLocation


final class SearchResultViewModel {
    
    //MARK: - Constants

    private let googlePlacesManager = GooglePlacesManager.shared
        
    //MARK: - Observable Variables

    let places = PublishSubject<[PlacesModel]>()
    let coordinates = PublishSubject<CLLocationCoordinate2D>()
    
    
    
    //MARK: - Fetch Places with GMSAutoCompleteFilter

    func fetchPlaces(_ query: String) {
        
        googlePlacesManager.findPlaces(query: query) { [weak self] places in
            if let places = places {
                self?.places.onNext(places)
            }
        } onError: { [weak self] error in
            self?.places.onError(error)
        }
        
    }
    
    //MARK: - Fetch Place Coordinates

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
