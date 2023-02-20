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
    
    var isSendingResetEmailSuccess = PublishSubject<Bool>()
    
    func sendPasswordResetEmail(_ email: String) {
        firebaseAuth.sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.isSendingResetEmailSuccess.onNext(true)
        }
    }

}
