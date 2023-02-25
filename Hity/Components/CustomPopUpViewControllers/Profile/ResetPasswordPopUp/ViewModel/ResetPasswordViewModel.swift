//
//  ResetPasswordViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 20.02.2023.
//


import FirebaseAuth
import RxSwift

final class ResetPasswordViewModel {
    
    //MARK: - Constants
    
    private let firebaseAuth = Auth.auth()
    
    //MARK: - Observable Variables
    
    let isEmailGettingSuccess = PublishSubject<String>()
    let isEmailGettingUnsuccessful = PublishSubject<Bool>()
    let isSendingResetEmail = PublishSubject<Bool>()
    let isSendingResetEmailSuccess = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    //MARK: - Send Password Reset Email
    
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
    
    //MARK: - Get User Email
    
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
