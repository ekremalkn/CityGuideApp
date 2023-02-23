//
//  DeleteAccountPopUpViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import FirebaseAuth
import RxSwift


final class DeleteAccountPopUpViewModel {
    
    private let firebaseAuth = Auth.auth()
    
    // observables
    
    let isCheckingEmails = PublishSubject<Bool>()
    let isCheckingEmailsSuccess = PublishSubject<Bool>()
    let isDeletingAccount = PublishSubject<Bool>()
    let isDeletingAccountSuccess = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    
    func checkAreEmailsMatching(_ email: String) {
        self.isCheckingEmails.onNext(true)
        if let currentUser = firebaseAuth.currentUser {
            if let userEmail = currentUser.email {
                if email == userEmail {
                    self.isCheckingEmails.onNext(false)
                    self.isCheckingEmailsSuccess.onNext(true)
                    // email eşleşmesi başarılı hesabı sil
                } else {
                    self.isCheckingEmails.onNext(false)
                    self.errorMsg.onNext("This email not yours.")
                    // email eşleşmesi başarısız callbacklabele yaz
                }
            }
        }
    }
    
    
    func deleteAccount() {
        self.isDeletingAccount.onNext(true)
        if let currentUser = firebaseAuth.currentUser {
            currentUser.delete { error in
                if let error = error {
                    self.isDeletingAccount.onNext(false)
                    self.errorMsg.onNext(error.localizedDescription)
                    // callback labele yazdır
                } else {
                    self.isDeletingAccount.onNext(false)
                    self.isDeletingAccountSuccess.onNext(true)
                    // giriş ekranına geri dön
                }
            }
        }
    }
}
