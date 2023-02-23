//
//  ResetPasswordViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 20.02.2023.
//


import FirebaseAuth
import RxSwift

final class ResetPasswordViewModel {
    
    //MARK: - Properties
    
    private let firebaseAuth = Auth.auth()
    
    // observabvle variables
    let isEmailGettingSuccess = PublishSubject<String>()
    let isEmailGettingUnsuccessful = PublishSubject<Bool>()
    let isSendingResetEmail = PublishSubject<Bool>()
    let isSendingResetEmailSuccess = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    func sendPasswordResetEmail(_ email: String) {
        self.isSendingResetEmail.onNext(true)
        firebaseAuth.sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.isSendingResetEmail.onNext(false)
                self?.errorMsg.onNext(error.localizedDescription)
                return
            }
            self?.isSendingResetEmail.onNext(false)
            self?.isSendingResetEmailSuccess.onNext(true)
        }
    }
    
    
    func getUserEmail() {
        if let currentUser = firebaseAuth.currentUser {
            if let email = currentUser.email {
                self.isEmailGettingSuccess.onNext(email)
            }
        } else {
            self.isEmailGettingUnsuccessful.onNext(true)
        }
    }

}
