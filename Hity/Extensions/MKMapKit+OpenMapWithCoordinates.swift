//
//  MKMapKit+OpenMapWithCoordinates.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import MapKit

extension MKMapItem {
    
    func openMapForPlace(_ lat: CLLocationDegrees, _ lng: CLLocationDegrees, _ placeName: String) {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = lng
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
}
