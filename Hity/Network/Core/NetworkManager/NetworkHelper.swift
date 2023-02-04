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
    case BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword="
    case API_KEY = ""
}

final class NetworkHelper {
    static let shared = NetworkHelper()
    
    public func request(input: String, lat: String, lng: String) -> String {
        return "\(NetworkEndPoint.BASE_URL.rawValue)\(input)&location=\(lat),\(lng)&radius=1000&key=\(NetworkEndPoint.API_KEY.rawValue)"
    }
}
