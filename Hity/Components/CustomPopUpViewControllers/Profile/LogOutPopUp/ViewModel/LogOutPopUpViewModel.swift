//
//  LogOutPopUpViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 22.02.2023.
//

import FirebaseAuth
import RxSwift

final class LogOutPopUpViewModel {
    
    //MARK: - Constants
    
    private let firebaseAuth = Auth.auth()
    
    //MARK: - Observable Variables
    
    let isSigningOutSuccess = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    //MARK: - Sign Out
    
    func signOut() {
        do {
            try firebaseAuth.signOut()
            self.isSigningOutSuccess.onNext(true)
        } catch {
            self.errorMsg.onNext(error.localizedDescription)
            print(error.localizedDescription)
        }
        
        
    }
    
}
