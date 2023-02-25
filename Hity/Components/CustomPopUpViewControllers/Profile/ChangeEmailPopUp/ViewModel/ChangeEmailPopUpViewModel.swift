//
//  ChangeEmailPopUpViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import FirebaseAuth
import RxSwift

final class ChangeEmailPopUpViewModel {
    
    //MARK: - Constants
    
    private let firebaseAuth = Auth.auth()
    
    //MARK: - Observable Variables
    
    let isChangingEmail = PublishSubject<Bool>()
    let isChangingEmailSuccess = PublishSubject<Bool>()
    let isFetchingEmail = PublishSubject<Bool>()
    let isFetchingEmailSuccess = PublishSubject<String>()
    let isSigningOut = PublishSubject<Bool>()
    let isSigningOutSuccess = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    
    //MARK: - Fetch Email
    
    func fetchEmail() {
        self.isFetchingEmail.onNext(true)
        if let currentUser = firebaseAuth.currentUser {
            if let email = currentUser.email {
                self.isFetchingEmail.onNext(false)
                self.isFetchingEmailSuccess.onNext(email)
            } else {
                self.isFetchingEmail.onNext(false)
                self.errorMsg.onNext("User not found.")
            }
        }
    }
    
    
    //MARK: - Change Email
    
    func changeEmail(_ email: String) {
        self.isChangingEmail.onNext(true)
        if let currentUser = firebaseAuth.currentUser {
            currentUser.updateEmail(to: email) { error in
                if let error = error {
                    self.isChangingEmail.onNext(false)
                    self.errorMsg.onNext(error.localizedDescription)
                } else {
                    self.isChangingEmail.onNext(false)
                    self.isChangingEmailSuccess.onNext(true)
                }
            }
        }
    }
    
    //MARK: - Sign Out
    
    func signOut() {
        self.isSigningOut.onNext(true)
        do {
            try firebaseAuth.signOut()
            self.isSigningOut.onNext(false)
            self.isSigningOutSuccess.onNext(true)
        } catch {
            self.isSigningOut.onNext(false)
            self.errorMsg.onNext(error.localizedDescription)
        }
    }
    
}
