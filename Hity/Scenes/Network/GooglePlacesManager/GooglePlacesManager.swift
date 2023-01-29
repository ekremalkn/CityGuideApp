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
    
    private func findPlaces(query: String, onSuccess: @escaping ([PlacesModel]?) -> (), onError: @escaping  (Error) -> ()) {
        let filter = GMSAutocompleteFilter()
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter , sessionToken: nil) { response, error in
            guard let response = response, error == nil else { return }
            
            let places: [PlacesModel] = response.compactMap( {
                PlacesModel(placeName: $0.attributedFullText.string, placeUID: $0.placeID)
            })
            onSuccess(places)
            
        }
    }
}
