//
//  GMSPlace.h
//  Google Places SDK for iOS
//
//  Copyright 2016 Google LLC
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#import "GMSPlacesDeprecationUtils.h"


@class GMSAddressComponent;
@class GMSOpeningHours;
@class GMSPlacePhotoMetadata;
@class GMSPlaceViewportInfo;
@class GMSPlusCode;

NS_ASSUME_NONNULL_BEGIN


/**
 * \defgroup PlacesPriceLevel GMSPlacesPriceLevel
 * @{
 */

/** Describes the price level of a place. */
typedef NS_ENUM(NSInteger, GMSPlacesPriceLevel) {
  kGMSPlacesPriceLevelUnknown = -1,
  kGMSPlacesPriceLevelFree = 0,
  kGMSPlacesPriceLevelCheap = 1,
  kGMSPlacesPriceLevelMedium = 2,
  kGMSPlacesPriceLevelHigh = 3,
  kGMSPlacesPriceLevelExpensive = 4,
};

/**@}*/

/**
 * \defgroup PlaceOpenStatus GMSPlaceOpenStatus
 * @{
 */

/** Describes the open status of a place. */
typedef NS_ENUM(NSInteger, GMSPlaceOpenStatus) {
  /** The place's open status is unknown. */
  GMSPlaceOpenStatusUnknown,

  /** The place is open. */
  GMSPlaceOpenStatusOpen,

  /** The place is not open. */
  GMSPlaceOpenStatusClosed,
};

/**@}*/

/**
 * \defgroup PlacesBusinessStatus GMSPlacesBusinessStatus
 * @{
 */

/** Describes the business status of a place. */
typedef NS_ENUM(NSInteger, GMSPlacesBusinessStatus) {
  /** The business status is not known. */
  GMSPlacesBusinessStatusUnknown,

  /** The business is operational. */
  GMSPlacesBusinessStatusOperational,

  /** The business is closed temporarily. */
  GMSPlacesBusinessStatusClosedTemporarily,

  /** The business is closed permanently. */
  GMSPlacesBusinessStatusClosedPermanently,
};

/**@}*/


/**
 * \defgroup BooleanPlaceAttribute GMSBooleanPlaceAttribute
 * @{
 */

/** Describes whether a place’s boolean attribute is available or not. */
typedef NS_ENUM(NSInteger, GMSBooleanPlaceAttribute) {
  /** The place's attribute has not been requested yet, or not known. */
  GMSBooleanPlaceAttributeUnknown,
  /** The place’s attribute is available. */
  GMSBooleanPlaceAttributeTrue,
  /** The place’s attribute is not available. */
  GMSBooleanPlaceAttributeFalse,
};

/**@}*/


/**
 * Represents a particular physical place. A GMSPlace encapsulates information about a physical
 * location, including its name, location, and any other information we might have about it. This
 * class is immutable.
 */
@interface GMSPlace : NSObject

/** Name of the place. */
@property(nonatomic, copy, readonly, nullable) NSString *name;

/** Place ID of this place. */
@property(nonatomic, copy, readonly, nullable) NSString *placeID;

/**
 * Location of the place. The location is not necessarily the center of the Place, or any
 * particular entry or exit point, but some arbitrarily chosen point within the geographic extent of
 * the Place.
 */
@property(nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;

/**
 * Phone number of this place, in international format, i.e. including the country code prefixed
 * with "+".  For example, Google Sydney's phone number is "+61 2 9374 4000".
 */
@property(nonatomic, copy, readonly, nullable) NSString *phoneNumber;

/** Address of the place as a simple string. */
@property(nonatomic, copy, readonly, nullable) NSString *formattedAddress;

/**
 * Five-star rating for this place based on user reviews.
 *
 * Ratings range from 1.0 to 5.0.  0.0 means we have no rating for this place (e.g. because not
 * enough users have reviewed this place).
 */
@property(nonatomic, readonly, assign) float rating;

/**
 * Price level for this place, as integers from 0 to 4.
 *
 * e.g. A value of 4 means this place is "$$$$" (expensive).  A value of 0 means free (such as a
 * museum with free admission).
 */
@property(nonatomic, readonly, assign) GMSPlacesPriceLevel priceLevel;

/**
 * The types of this place.  Types are NSStrings, valid values are any types documented at
 * <https://developers.google.com/places/ios-sdk/supported_types>.
 */
@property(nonatomic, copy, readonly, nullable) NSArray<NSString *> *types;

/** Website for this place. */
@property(nonatomic, copy, readonly, nullable) NSURL *website;

/**
 * The data provider attribution string for this place.
 *
 * These are provided as a NSAttributedString, which may contain hyperlinks to the website of each
 * provider.
 *
 * In general, these must be shown to the user if data from this GMSPlace is shown, as described in
 * the Places SDK Terms of Service.
 */
@property(nonatomic, copy, readonly, nullable) NSAttributedString *attributions;

/**
 * The recommended viewport for this place. May be nil if the size of the place is not known.
 *
 * This returns a viewport of a size that is suitable for displaying this place. For example, a
 * |GMSPlace| object representing a store may have a relatively small viewport, while a |GMSPlace|
 * object representing a country may have a very large viewport.
 */
@property(nonatomic, strong, readonly, nullable) GMSPlaceViewportInfo *viewportInfo;

/**
 * An array of |GMSAddressComponent| objects representing the components in the place's address.
 * These components are provided for the purpose of extracting structured information about the
 * place's address: for example, finding the city that a place is in.
 *
 * These components should not be used for address formatting. If a formatted address is required,
 * use the |formattedAddress| property, which provides a localized formatted address.
 */
@property(nonatomic, copy, readonly, nullable) NSArray<GMSAddressComponent *> *addressComponents;

/** The Plus code representation of location for this place. */
@property(nonatomic, strong, readonly, nullable) GMSPlusCode *plusCode;

/**
 * The Opening Hours information for this place. Includes open status, periods and weekday text when
 * available.
 */
@property(nonatomic, strong, readonly, nullable) GMSOpeningHours *openingHours;

/** Represents how many reviews make up this place's rating. */
@property(nonatomic, readonly, assign) NSUInteger userRatingsTotal;

/** An array of |GMSPlacePhotoMetadata| objects representing the photos of the place. */
@property(nonatomic, copy, readonly, nullable) NSArray<GMSPlacePhotoMetadata *> *photos;

/** The timezone UTC offset of the place in minutes. */
@property(nonatomic, readonly, nullable) NSNumber *UTCOffsetMinutes;

/** The |GMSPlaceBusinessStatus| of the place. */
@property(nonatomic, readonly) GMSPlacesBusinessStatus businessStatus;

/** Default init is not available. */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Calculates if a place is open based on |openingHours|, |UTCOffsetMinutes|, and |date|.
 *
 * @param date A reference point in time used to determine if the place is open.
 * @return GMSPlaceOpenStatusOpen if the place is open, GMSPlaceOpenStatusClosed if the place is
 *     closed, and GMSPlaceOpenStatusUnknown if the open status is unknown.
 */
- (GMSPlaceOpenStatus)isOpenAtDate:(NSDate *)date;

/**
 * Calculates if a place is open based on |openingHours|, |UTCOffsetMinutes|, and current date
 * and time obtained from |[NSDate date]|.
 *
 * @return GMSPlaceOpenStatusOpen if the place is open, GMSPlaceOpenStatusClosed if the place is
 *     closed, and GMSPlaceOpenStatusUnknown if the open status is unknown.
 */
- (GMSPlaceOpenStatus)isOpen;

/** Background color of the icon according to Place type, to color the view behind the icon. */
@property(nonatomic, readonly, nullable) UIColor *iconBackgroundColor;

/**
 * The URL according to Place type, which you can use to retrieve the NSData of the Place icon.
 * NOTES: URL link does not expire and the image size aspect ratio may be different depending on
 * type.
 */
@property(nonatomic, readonly, nullable) NSURL *iconImageURL;


/** Place Attribute for takeout experience. */
@property(nonatomic, readonly) GMSBooleanPlaceAttribute takeout;

/** Place Attribute for delivery services. */
@property(nonatomic, readonly) GMSBooleanPlaceAttribute delivery;

/** Place Attribute for dine in experience. */
@property(nonatomic, readonly) GMSBooleanPlaceAttribute dineIn;

/** Place Attribute for curbside pickup services. */
@property(nonatomic, readonly) GMSBooleanPlaceAttribute curbsidePickup;


@end

NS_ASSUME_NONNULL_END
