//
//  ChangeUsernamePopUpVieModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import FirebaseAuth
import RxSwift


final class ChangeUsernamePopUpVieModel {
    
    
    //MARK: - Properties
    
    private let firebaseAuth = Auth.auth()
    
    private let disposeBag = DisposeBag()
    
    // obsevable
    
    let isChangingUsername = PublishSubject<Bool>()
    let isChangingUsernameSuccess = PublishSubject<Bool>()
    let isFetchingUserDisplayName = PublishSubject<String>()
    let errorMsg = PublishSubject<String>()
    
    func changeUsername(_ newUsename: String) {
        self.isChangingUsername.onNext(true)
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newUsename
        changeRequest?.commitChanges { [weak self] error in
            if let error = error {
                self?.isChangingUsername.onNext(false)
                self?.errorMsg.onNext(error.localizedDescription)
            }
            self?.isChangingUsername.onNext(false)
            self?.isChangingUsernameSuccess.onNext(true)
        }
        
    }
    
    
    func fetchUserDisplayName() {
        if let currentUser = firebaseAuth.currentUser {
            if let userDisplayName = currentUser.displayName {
                self.isFetchingUserDisplayName.onNext(userDisplayName)
            } else {
                self.isFetchingUserDisplayName.onNext("Nameless User")
            }
            
        }
    }

}
