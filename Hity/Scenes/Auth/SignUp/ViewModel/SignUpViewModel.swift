//
//  SignUpViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 11.02.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


final class SignUpViewModel {
    
    
    //MARK: - Properties
    
    private let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    //MARK: - SignUpMethod
    
    func signUp(_ username: String, _ email: String, _ password: String) {
        
        firebaseAuth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let changeRequest = self?.firebaseAuth.currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
            
            if let email = authResult?.user.email, let uid = authResult?.user.uid {
                let favorite: [Int: String] = [:]
                let user = User(id: uid, username: username, email: email, favorite: favorite)
                
                // Creating FirstoreDatabase each different User
                self?.database.collection("Users").document(uid).setData(user.dictionary) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Kullanıcıya özel database oluşturuldu.")
                }
                
            }
            
        }
    }
    
    
}
