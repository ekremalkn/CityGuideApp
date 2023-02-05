//
//  WebService.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import Alamofire

protocol ServiceProtocol {
    func nearyBySearch(input: String, lat: String, lng: String, onSuccess: @escaping (NearPlacesModel?) -> (), onError: @escaping (AFError) -> ())
    func placeDetail(placeUID: String, onSuccess: @escaping (Place?) -> (), onError: @escaping (AFError) -> ())
}


final class Service: ServiceProtocol {



    static let shared = Service()
    
    
   public func nearyBySearch(input: String, lat: String, lng: String, onSuccess: @escaping (NearPlacesModel?) -> (), onError: @escaping (Alamofire.AFError) -> ()) {
       NetworkManager.shared.request(path: NetworkHelper.shared.nearPlaceRequest(input: input, lat: lat, lng: lng)) { (response: NearPlacesModel?) in
            onSuccess(response)
        } onError: { error in
            onError(error)
        }

    }

    
   public func placeDetail(placeUID: String, onSuccess: @escaping (Place?) -> (), onError: @escaping (Alamofire.AFError) -> ()) {
       NetworkManager.shared.request(path: NetworkHelper.shared.placeDetailRequest(placeUID: placeUID)) { (response: Place?) in
           onSuccess(response)
       } onError: { error in
           onError(error)
       }

    }
    

        
    
    
}
