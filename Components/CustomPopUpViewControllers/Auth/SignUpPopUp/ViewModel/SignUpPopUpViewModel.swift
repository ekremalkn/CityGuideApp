////
////  SignUpPopUpViewModel.swift
////  Hity
////
////  Created by Ekrem Alkan on 22.02.2023.
////
//
//import FirebaseAuth
//import RxSwift
//
//
//final class SignUpPopUpViewModel {
//
//    private let firebaseAuth = Auth.auth()
//
//    let isSendEmailSuccess = PublishSubject<Bool>()
//    let isSendingEmail = PublishSubject<Bool>()
//
//
//    func sendEmailVerificationLink() {
//        self.isSendingEmail.onNext(true)
//        if let currentUser = firebaseAuth.currentUser {
//            currentUser.sendEmailVerification { error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    self.isSendingEmail.onNext(false)
//                    self.isSendEmailSuccess.onNext(false)
//                    return
//                }
//                self.isSendingEmail.onNext(false)
//                self.isSendEmailSuccess.onNext(true)
//            }
//        }
//    }
//
//}
