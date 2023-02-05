//
//  PlaceDetailModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 5.02.2023.
//

import Foundation

// MARK: - Place
struct Place: Codable {
    let result: DetailResults?
    let status: String?
}

// MARK: - Result
struct DetailResults: Codable {
    let businessStatus: String?
    let currentOpeningHours: DetailCurrentOpeningHours?
    let delivery: Bool?
    let formattedAddress, formattedPhoneNumber: String?
    let geometry: DetailGeometry?
    let icon: String?
    let iconBackgroundColor: String?
    let iconMaskBaseURI: String?
    let internationalPhoneNumber, name: String?
    let photos: [DetailPhoto]?
    let placeID: String?
    let plusCode: DetailPlusCode?
    let priceLevel: Int?
    let rating: Double?
    let reference: String?
    let reviews: [DetailReview]?
    let takeout: Bool?
    let types: [String]?
    let url: String?
    let userRatingsTotal, utcOffset: Int?
    let vicinity: String?
    let website: String?
    let wheelchairAccessibleEntrance: Bool?

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case currentOpeningHours = "current_opening_hours"
        case delivery
        case formattedAddress = "formatted_address"
        case formattedPhoneNumber = "formatted_phone_number"
        case geometry, icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case internationalPhoneNumber = "international_phone_number"
        case name, photos
        case placeID = "place_id"
        case plusCode = "plus_code"
        case priceLevel = "price_level"
        case rating, reference, reviews, takeout, types, url
        case userRatingsTotal = "user_ratings_total"
        case utcOffset = "utc_offset"
        case vicinity, website
        case wheelchairAccessibleEntrance = "wheelchair_accessible_entrance"
    }
}

// MARK: - CurrentOpeningHours
struct DetailCurrentOpeningHours: Codable {
    let openNow: Bool?
    let weekdayText: [String]?

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case weekdayText = "weekday_text"
    }
}

// MARK: - Geometry
struct DetailGeometry: Codable {
    let location: DetailLocation?
}

// MARK: - Location
struct DetailLocation: Codable {
    let lat, lng: Double?
}

// MARK: - Photo
struct DetailPhoto: Codable {
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
struct DetailPlusCode: Codable {
    let compoundCode, globalCode: String?

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

// MARK: - Review
struct DetailReview: Codable {
    let authorName: String?
    let authorURL: String?
    let language, originalLanguage: String?
    let profilePhotoURL: String?
    let rating: Int?
    let relativeTimeDescription, text: String?
    let time: Int?
    let translated: Bool?

    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorURL = "author_url"
        case language
        case originalLanguage = "original_language"
        case profilePhotoURL = "profile_photo_url"
        case rating
        case relativeTimeDescription = "relative_time_description"
        case text, time, translated
    }
}
