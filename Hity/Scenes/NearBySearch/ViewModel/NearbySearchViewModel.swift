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
    
    //MARK: - Constants
    
    private let webServiceManager = Service.shared
    private let database = Firestore.firestore()
    private let firebaseAuth = Auth.auth()
    
    //MARK: - Observable Variables
    
    let nearPlaces = PublishSubject<[Result]>()
    let placeDetails = PublishSubject<DetailResults>()
    
    
    //MARK: - Fetch Near Places
    
    func fetchNearPlaces(_ input: String, _ lat: Double, _ lng: Double, searchDistance: String, sortType: SortTypesTitle) {
        
        webServiceManager.nearyBySearch(input: input, lat: lat, lng: lng, searchDistance: searchDistance) { [weak self] nearPlaces in
            if let nearPlaces = nearPlaces?.results {
                
                switch sortType {
                    
                case .logic:
                    self?.nearPlaces.onNext(nearPlaces)
                case .maxToMinRating:
                    let sortedPlaces = nearPlaces.sorted {
                        $0.rating ?? 0 > $1.rating ?? 0 }
                    self?.nearPlaces.onNext(sortedPlaces)
                case .userRatingTotal:
                    let sortesPlaces = nearPlaces.sorted {
                        $0.userRatingsTotal ?? 0 > $1.userRatingsTotal ?? 0
                    }
                    self?.nearPlaces.onNext(sortesPlaces)
                }
                
            }
        } onError: { error in
            self.nearPlaces.onError(error)
        }
        
    }
    
    //MARK: - Fetch Place Details
    
    func fetchPlaceDetails(_ placeUID: String) {
        
        webServiceManager.placeDetail(placeUID: placeUID) { [weak self] place in
            if let placeDetails = place?.result {
                self?.placeDetails.onNext(placeDetails)
            }
        } onError: { [weak self] error in
            self?.placeDetails.onError(error)
        }
        
    }
    
    
    //MARK: - Write placeUID to FirestoreDatabase

    
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
