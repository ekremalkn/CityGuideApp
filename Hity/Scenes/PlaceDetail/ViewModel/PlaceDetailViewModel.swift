//
//  PlaceDetailViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import RxSwift
import FirebaseAuth
import FirebaseFirestore


final class PlaceDetailViewModel {
    
    private let webServiceManager = Service.shared
    
    // Observable variables
    var placeReviews = PublishSubject<[DetailReview]>()
    var isPlaceInFavoriteList = PublishSubject<Bool>()
    
    //Firebase properties
    
    private let firebaseAuth = Auth.auth()
    private let database = Firestore.firestore()
    
    var favoriteList: [String: Int]? = [:]
    
    func fetchPlaceReviews(_ placeUID: String) {
        
        webServiceManager.placeDetail(placeUID: placeUID) { [weak self] place in
            if let placeReviews = place?.result?.reviews {
                self?.placeReviews.onNext(placeReviews)
            }
        } onError: { [weak self] error in
            self?.placeReviews.onError(error)
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
    
    
    // fetch favorite list
    
    func fetchFavoriteListFromFirestore(_ placeUID: String) {
        guard let currentUser = firebaseAuth.currentUser else { return }
        
        let favoriteListRef = database.collection("Users").document(currentUser.uid)
        
        favoriteListRef.getDocument(source: .default) { [weak self] documentData, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let documentData = documentData else { return }
            guard let favoriteList = documentData.get("favorite") as? [String: Int] else { return }
            self?.favoriteList = favoriteList
            
            if let favoriteList = self?.favoriteList {
                for (id, _ ) in favoriteList {
                    if id == placeUID {
                        self?.isPlaceInFavoriteList.onNext(true)
                    } else {
                        self?.isPlaceInFavoriteList.onNext(false)
                    }
                }
            }
            
            
        }
    }
}
