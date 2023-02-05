//
//  NetworkHelper.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import Foundation
import CoreLocation

enum NetworkEndPoint: String {
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=spor%20salonu&location=36.8683629,30.7230041&radius=1000&key=APIKEY
    //https://maps.googleapis.com/maps/api/place/details/json?fields=&place_id=ChIJR5h_yKKawxQRWB6O9t6m81M&key=AIzaSyAkPTDhADLekUMuAMbmMWmSYD_v_bAboQg
    case NEAR_PLACE_BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword="
    case PLACE_DETAIL_BASE_URL = "https://maps.googleapis.com/maps/api/place/details/json?fields=&place_id="
}

enum ApiKey: String {
    case API_KEY = "AIzaSyAkPTDhADLekUMuAMbmMWmSYD_v_bAboQg"
}

final class NetworkHelper {
    static let shared = NetworkHelper()
    
        public func nearPlaceRequest(input: String, lat: String, lng: String) -> String {
            return "\(NetworkEndPoint.NEAR_PLACE_BASE_URL.rawValue)\(input)&location=\(lat),\(lng)&radius=1000&key=\(ApiKey.API_KEY.rawValue)"
        }
    
       public func placeDetailRequest(placeUID: String) -> String {
            return "\(NetworkEndPoint.PLACE_DETAIL_BASE_URL.rawValue)\(placeUID)&key=\(ApiKey.API_KEY.rawValue)"
        }
        
    
}



