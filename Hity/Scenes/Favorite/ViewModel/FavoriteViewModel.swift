//
//  FavoriteViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 17.02.2023.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

protocol FavoriteViewModelDelegate: AnyObject {
    func isAppendedToArray()
}

final class FavoriteViewModel {
    
    weak var delegate: FavoriteViewModelDelegate?
    // WebService Manager
    private let webServiceManager = Service.shared
    
    // Firebase properties
    
    private let database = Firestore.firestore()
    private let firebaseAuth = Auth.auth()
    
    // observable variables
    
    var isListUpdated = PublishSubject<Bool>()
    var behaviorFavoriteList = BehaviorRelay<[DetailResults]>(value: [])
    var rastgele = BehaviorRelay<[DetailResults]>(value: [])
    
    
    
    
    // write placeUID to firebase FirestoreDatabase
    
    func updateFirestoreFavoriteList(_ placeUID: String, _ isAdded: Bool) {
        guard let currentUser = firebaseAuth.currentUser else { return }
        
        let userRef = database.collection("Users").document(currentUser.uid)
        
        if !isAdded {
            
            userRef.updateData(["favorite.\(placeUID)" : FieldValue.delete()]) { error in
                if let error = error {
                    print(error)
                }
                self.isListUpdated.onNext(true)
            }
        }
    }
    
    // fetch favorite list
    
    func fetchFavoriteList() {
        guard let currentUser = firebaseAuth.currentUser else { return }
        let userRef  = database.collection("Users").document(currentUser.uid)
        
        userRef.getDocument(source: .default) { [unowned self] documentData, error in
            if let _ = error {
                
            }
            
            guard let documentData = documentData else { return }
            guard let favoriteList = documentData.get("favorite") as? [String: Int] else { return }
            var array = behaviorFavoriteList.value
            array.removeAll()
            self.behaviorFavoriteList.accept(array)
            print("başladı")
            for (id, _) in favoriteList {
                self.fetchPlace(id)
            }
        }
    }
    
    // fetch place details
    
    private func fetchPlace(_ id: String) {
        webServiceManager.placeDetail(placeUID: id) { [unowned self] place in
            if let place = place?.result {
                
                if !self.behaviorFavoriteList.value.contains(where: { place in
                    return place.placeID == id
                }) {
                    let array = self.behaviorFavoriteList.value
                    self.behaviorFavoriteList.accept(array + [place])
                }
                
            }
        } onError: { error in
            print(error.localizedDescription)
        }
        
        
        
    }
    
    
    
    //MARK: - GetProductIndexPath
    
    func getProductIndexPath(placeUID: String) -> IndexPath {
        let array = self.behaviorFavoriteList.value
        let index = array.firstIndex { place  in
            place.placeID == placeUID
        }
        if let index = index {
            return IndexPath(row: index, section: 0)
        }
        return IndexPath()
    }
    
    //MARK: - RemoveProduct
    
    func removeProduct(index: Int) {
        var array = self.behaviorFavoriteList.value
            array.remove(at: index)
        
    }
    
}
