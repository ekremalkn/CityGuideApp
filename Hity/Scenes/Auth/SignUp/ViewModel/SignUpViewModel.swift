//
//  SignUpViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 11.02.2023.
//

import FirebaseAuth
import FirebaseFirestore
import RxSwift


final class SignUpViewModel {
    
    
    //MARK: - Properties
    
    private let database = Firestore.firestore()
    private let firebaseAuth = Auth.auth()
    
    // Fields that bind to our view's
    
    let isAccCreatingSuccess = PublishSubject<Bool>()
    let isAccCreating = PublishSubject<Bool>()
    let isDatabaseCreatingSuccess = PublishSubject<Bool>()
    let isDatabaseCreating = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    //MARK: - Sign Up with Email
    
    func signUp(_ username: String, _ email: String, _ password: String) {
        
        self.isAccCreating.onNext(true)
        
        firebaseAuth.createUser(withEmail: email, password: password) { [weak self] authResult, authError in
            if let authError = authError {
                self?.isAccCreating.onNext(false)
                self?.errorMsg.onNext(authError.localizedDescription)
                return
            }
            
            guard let authResult = authResult else { return }
            // created acc
            self?.isAccCreating.onNext(false)
            self?.isAccCreatingSuccess.onNext(true)
            self?.changeUserDisplayName(username)
            self?.createDatabaseForUser(authResult, username)
            
        }
    }
    
    //MARK: - Create User Database
    
    private func createDatabaseForUser(_ authResult: AuthDataResult, _ username: String) {
        self.isDatabaseCreating.onNext(true)
        let email = authResult.user.email
        let uid = authResult.user.uid
        let favorite: [String: Int] = [:]
        let user = User(id: uid, username: username, email: email, favorite: favorite)
        
        // Creating FirstoreDatabase each different User
        self.database.collection("Users").document(uid).setData(user.dictionary) { [weak self] error in
            if let error = error {
                self?.isDatabaseCreating.onNext(false)
                self?.errorMsg.onNext(error.localizedDescription)
                return
            }
            // created database
            self?.isDatabaseCreating.onNext(false)
            self?.isDatabaseCreatingSuccess.onNext(true)
        }
        
    }
    
    //MARK: - Change User Display Name
    
    private func changeUserDisplayName(_ username: String) {
        let changeRequest = self.firebaseAuth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges(completion: { [weak self] error in
            if let error = error {
                self?.errorMsg.onNext(error.localizedDescription)
                return
            }
        })
    }
    
    //MARK: - Sign Out
    
    func signOut() {
        do {
            try firebaseAuth.signOut()
        } catch {
            self.errorMsg.onNext(error.localizedDescription)
            print(error.localizedDescription)
        }
    }

    
    
}
