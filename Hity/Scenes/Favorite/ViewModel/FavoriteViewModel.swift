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

final class FavoriteViewModel {
    
    //MARK: - Constants

    private let webServiceManager = Service.shared
    private let database = Firestore.firestore()
    private let firebaseAuth = Auth.auth()
    

    //MARK: - Observable Variables

    let isListUpdated = PublishSubject<Bool>()
    let behaviorFavoriteList = BehaviorRelay<[DetailResults]>(value: [])
    
    
    
    //MARK: - Fetch Favorite List

    func fetchFavoriteList() {
        guard let currentUser = firebaseAuth.currentUser else { return }
        let userRef  = database.collection("Users").document(currentUser.uid)
        
        userRef.getDocument(source: .default) { [unowned self] documentData, error in
            // if get error while getting document
            if let _ = error {
                
            }
            
            guard let documentData = documentData else { return }
            // if documentData not nil
            guard let favoriteList = documentData.get("favorite") as? [String: Int] else { return }
            // if favoriteList got correct form
            var array = behaviorFavoriteList.value
            // first get array current value
            array.removeAll()
            // second remove all value because don't want to add same items
            self.behaviorFavoriteList.accept(array)
            // third add array

            for (id, _) in favoriteList {
                self.fetchPlace(id)
                // four ->
            }
        }
    }
    
    //MARK: - Fetch Place and add to BehaviorArray

    private func fetchPlace(_ id: String) {
        // four fetching place according to placeUID
        webServiceManager.placeDetail(placeUID: id) { [unowned self] place in
            if let place = place?.result {
                // if fetched place
                
                if !self.behaviorFavoriteList.value.contains(where: { place in
                    // fifth check if array already has the place
                    return place.placeID == id
                }) {
                    // sixth if there is no same place in array before
                    let array = self.behaviorFavoriteList.value
                    // seventh get array current value
                    self.behaviorFavoriteList.accept(array + [place])
                    // eight add to new place to array
                }
            }
        } onError: { error in
            print(error.localizedDescription)
        }
        
        
        
    }
    
    
    //MARK: - Write placeUID to  FirestoreDatabase

    func updateFirestoreFavoriteList(_ placeUID: String, _ isAdded: Bool) {
        guard let currentUser = firebaseAuth.currentUser else { return }
        
        let userRef = database.collection("Users").document(currentUser.uid)
        
        if !isAdded {
            // delete 
            userRef.updateData(["favorite.\(placeUID)" : FieldValue.delete()]) { error in
                if let error = error {
                    print(error)
                }
                self.isListUpdated.onNext(true)
            }
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
