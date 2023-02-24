//
//  GooglePlacesManager.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import Foundation
import GooglePlaces

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    public func findPlaces(query: String, onSuccess: @escaping ([PlacesModel]?) -> (), onError: @escaping  (Error) -> ()) {
        let filter = GMSAutocompleteFilter()
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter , sessionToken: nil) { response, error in
            guard let response = response, error == nil else { return }
            
            let places: [PlacesModel] = response.compactMap( {
                PlacesModel(placeName: $0.attributedFullText.string, placeUID: $0.placeID)
            })

            onSuccess(places)
            
        }
    }
    
    public func fetchCoordinates(placeUID: String, onSuccess: @escaping (CLLocationCoordinate2D?) -> (), onError: @escaping (Error) -> ()) {
        client.fetchPlace(fromPlaceID: placeUID, placeFields: .coordinate, sessionToken: nil) { response, error in
            
            guard let response = response, error == nil else { return }
            
            let coordinates = CLLocationCoordinate2D(latitude: response.coordinate.latitude, longitude: response.coordinate.longitude)
            
            onSuccess(coordinates)
        }
    }

    
}
