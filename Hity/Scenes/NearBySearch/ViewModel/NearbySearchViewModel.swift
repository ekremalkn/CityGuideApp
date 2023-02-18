//
//  NearbySearchViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import RxSwift
import FirebaseAuth
import FirebaseFirestore


final class NearbySearchViewModel {
    
    private let webServiceManager = Service.shared
    
    private let database = Firestore.firestore()
    private let firebaseAuth = Auth.auth()
    
    var nearPlaces = PublishSubject<[Result]>()
    var placeDetails = PublishSubject<DetailResults>()

    
    func fetchNearPlaces(_ input: String, _ lat: Double, _ lng: Double) {

        webServiceManager.nearyBySearch(input: input, lat: lat, lng: lng) { [weak self] nearPlaces in
            if let nearPlaces = nearPlaces?.results {
                self?.nearPlaces.onNext(nearPlaces)
            }
        } onError: { error in
            self.nearPlaces.onError(error)
        }

    }
    
        func fetchPlaceDetails(_ placeUID: String) {
    
            webServiceManager.placeDetail(placeUID: placeUID) { [weak self] place in
                if let placeDetails = place?.result {
                    self?.placeDetails.onNext(placeDetails)
                }
            } onError: { [weak self] error in
                self?.placeDetails.onError(error)
            }
    
    
    
        }
    
    // write placeUID to firebase FirestoreDatabase
    
    func updateFirestoreFavoriteList(_ placeUID: String, _ isAdded: Bool) {
        guard let currentUser = firebaseAuth.currentUser else { return }
        
        let userRef = database.collection("Users").document(currentUser.uid)
        
        if isAdded {
            userRef.updateData(["favorite.\(placeUID)" : 1]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }
        } else {
            userRef.updateData(["favorite.\(placeUID)" : FieldValue.delete()]) { error in
                if let error = error {
                    print(error)
                }
                
            }
        }
    }
}
