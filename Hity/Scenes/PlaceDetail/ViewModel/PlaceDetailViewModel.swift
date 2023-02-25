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
    
    //MARK: - Constants
    
    private let webServiceManager = Service.shared
    private let firebaseAuth = Auth.auth()
    private let database = Firestore.firestore()
    
    //MARK: - Observable Variables
    
    let aPlaceReview = PublishSubject<[DetailReview]>()
    let noReviews = PublishSubject<Bool>()
    let isPlaceInFavoriteList = PublishSubject<Bool>()
    
    //MARK: - Firebase Favorite List Variable
    
    var favoriteList: [String: Int]? = [:]
    
    //MARK: - Fetch Place Reviews
    
    func fetchPlaceReviews(_ placeUID: String) {
        
        webServiceManager.placeDetail(placeUID: placeUID) { [weak self] place in
            if let placeReviews = place?.result?.reviews {
                let randomInt = Int.random(in: 0..<placeReviews.count)
                let array = Array(arrayLiteral: placeReviews[randomInt])
                self?.aPlaceReview.onNext(array)
            } else {
                self?.noReviews.onNext(true)
            }
        } onError: { [weak self] error in
            self?.aPlaceReview.onError(error)
        }
        
        
    }
    
    
    //MARK: - Write placeUID to FirestoreDatabase
    
    func updateFirestoreFavoriteList(_ placeUID: String, _ isAdded: Bool) {
        guard let currentUser = firebaseAuth.currentUser else { return }
        
        let userRef = database.collection("Users").document(currentUser.uid)
        
        if isAdded {
            // add to firestoredatabase
            userRef.updateData(["favorite.\(placeUID)" : 1]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }
        } else {
            // delete from firestoredatabase
            userRef.updateData(["favorite.\(placeUID)" : FieldValue.delete()]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    
    //MARK: - Fetch Favorite List
    
    func fetchFavoriteListFromFirestore(_ placeUID: String) {
        guard let currentUser = firebaseAuth.currentUser else { return }
        
        let favoriteListRef = database.collection("Users").document(currentUser.uid)
        
        favoriteListRef.getDocument(source: .default) { [weak self] documentData, error in
            if let error = error {
                //if error not nil
                print(error.localizedDescription)
            }
            
            guard let documentData = documentData else { return }
            //if User datas not nil-->
            guard let favoriteList = documentData.get("favorite") as? [String: Int] else { return }
            //ifr favorite list not nil-->
            self?.favoriteList = favoriteList
            
            // checking  being looked place is in favorite list
            if let favoriteList = self?.favoriteList {
                if favoriteList.count == 0 {
                    // for handle fav button selection
                    self?.isPlaceInFavoriteList.onNext(false)
                } else {
                    for (id, _ ) in favoriteList {
                        if id == placeUID {
                            // for handle fav button selection
                            self?.isPlaceInFavoriteList.onNext(true)
                        } else if id != placeUID || favoriteList.count == 0 {
                            // for handle fav button selection
                            self?.isPlaceInFavoriteList.onNext(false)
                        }
                    }
                }
                
            }
            
            
        }
    }
}
