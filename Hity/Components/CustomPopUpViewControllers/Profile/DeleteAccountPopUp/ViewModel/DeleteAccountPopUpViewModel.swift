//
//  DeleteAccountPopUpViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import FirebaseAuth
import RxSwift


final class DeleteAccountPopUpViewModel {
    
    //MARK: - Setup Constraints
    
    private let firebaseAuth = Auth.auth()
    
    //MARK: - Observable Variables
    
    let isCheckingEmails = PublishSubject<Bool>()
    let isCheckingEmailsSuccess = PublishSubject<Bool>()
    let isDeletingAccount = PublishSubject<Bool>()
    let isDeletingAccountSuccess = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    //MARK: - Check Emails Matching
    
    func checkAreEmailsMatching(_ email: String) {
        self.isCheckingEmails.onNext(true)
        if let currentUser = firebaseAuth.currentUser {
            if let userEmail = currentUser.email {
                if email == userEmail {
                    self.isCheckingEmails.onNext(false)
                    self.isCheckingEmailsSuccess.onNext(true)
                    // emails matched
                } else {
                    self.isCheckingEmails.onNext(false)
                    self.errorMsg.onNext("This email not yours.")
                    // email did not matched
                }
            }
        }
    }
    
    //MARK: - Delete Account
    
    func deleteAccount() {
        self.isDeletingAccount.onNext(true)
        if let currentUser = firebaseAuth.currentUser {
            currentUser.delete { error in
                if let error = error {
                    self.isDeletingAccount.onNext(false)
                    self.errorMsg.onNext(error.localizedDescription)
                    // account did not deleted
                } else {
                    self.isDeletingAccount.onNext(false)
                    self.isDeletingAccountSuccess.onNext(true)
                    // account deleted go to sign in vc
                }
            }
        }
    }
}
