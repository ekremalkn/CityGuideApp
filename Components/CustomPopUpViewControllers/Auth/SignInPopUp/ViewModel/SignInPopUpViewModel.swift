//
//  SignInPopUpViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 22.02.2023.
//

import FirebaseAuth
import RxSwift


final class SignInPopUpViewModel {
    
    private let firebaseAuth = Auth.auth()

    let isSendEmailSuccess = PublishSubject<Bool>()
    let isSendingEmail = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    
    func sendEmailVerificationLink() {
        self.isSendingEmail.onNext(true)
        if let currentUser = firebaseAuth.currentUser {
            currentUser.sendEmailVerification { error in
                if let error = error {
                    self.isSendingEmail.onNext(false)
                    self.errorMsg.onNext(error.localizedDescription)
                    return
                }
                self.isSendingEmail.onNext(false)
                self.isSendEmailSuccess.onNext(true)
            }
        }
    }
    
    func signOut() {
            do {
                try firebaseAuth.signOut()
            } catch {
                self.errorMsg.onNext(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    
}
