//
//  NearPlacesModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import Foundation

// MARK: - Places
struct NearPlacesModel: Codable {
    let results: [Result]?
    let status: String?
}

// MARK: - Result
struct Result: Codable, NearbyPlacesCellProtocol {
 
    let businessStatus: String?
    let geometry: Geometry?
    let icon: String?
    let iconBackgroundColor: String?
    let iconMaskBaseURI: String?
    let name: String?
    let openingHours: OpeningHours?
    let photos: [Photo]?
    let placeID: String?
    let plusCode: PlusCode?
    let rating: Double?
    let reference, scope: String?
    let types: [String]?
    let userRatingsTotal: Int?
    let vicinity: String?
    
    var placeImage: String {
        if let photo = photos?[0].photoReference  {
            return photo
        }
        return ""
    }
    
    var placeName: String {
        if let name = name {
            return name
        }
        return ""
    }
    
    var placeAddress: String {
        if let address = vicinity {
            return address
        }
        return ""
    }
    
    var placeOpenClosedInfo: String {
        if let openClosedInfo = openingHours?.openNow {
            if openClosedInfo {
                return "Açık"
            } else {
                return "Kapalı"
            }
        }
        return "Açık/Kapalı bilgisi yok."
    }
    
    var placeRating: String {
        if let rating = rating {
            return "\(rating)"
        }
        return ""
    }
    
    var placeTotalRatings: String {
        if let userRatingsTotal = userRatingsTotal {
            return "\(userRatingsTotal)"
        }
        return ""
    }
    
    
    

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry, icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case name
        case openingHours = "opening_hours"
        case photos
        case placeID = "place_id"
        case plusCode = "plus_code"
        case rating, reference, scope, types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location?
    let viewport: Viewport?
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double?
}

// MARK: - Viewport
struct Viewport: Codable {
    let northeast, southwest: Location?
}

// MARK: - OpeningHours
struct OpeningHours: Codable {
    let openNow: Bool?

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

// MARK: - Photo
struct Photo: Codable {
    let height: Int?
    let photoReference: String?
    let width: Int?

    enum CodingKeys: String, CodingKey {
        case height
        case photoReference = "photo_reference"
        case width
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String?

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}
