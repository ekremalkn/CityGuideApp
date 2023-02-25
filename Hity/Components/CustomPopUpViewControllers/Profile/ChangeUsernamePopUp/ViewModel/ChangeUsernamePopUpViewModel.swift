//
//  ChangeUsernamePopUpViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import FirebaseAuth
import RxSwift


final class ChangeUsernamePopUpViewModel {
    
    //MARK: - Constants
    private let firebaseAuth = Auth.auth()
    
    //MARK: - Observable Variables
    
    let isChangingUsername = PublishSubject<Bool>()
    let isChangingUsernameSuccess = PublishSubject<Bool>()
    let isFetchingUserDisplayName = PublishSubject<String>()
    let errorMsg = PublishSubject<String>()
    
    //MARK: - Dispose Bag
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Change Username
    
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
    
    //MARK: - Fetch Username
    
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
