//
//  ProfileViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 20.02.2023.
//



import FirebaseAuth
import FirebaseStorage
import RxSwift

final class ProfileViewModel {
    
    private let firebaseAuth = Auth.auth()
    
    private let storage = Storage.storage().reference()
    
    
    //observable variables
    
    let isUploadingSuccess = PublishSubject<Bool>()
    let isDownloadingURLSuccess = PublishSubject<String>()
    let isSigningOutSuccess = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()

    
    func uploadImageDataToFirebaseStorage(_ imageData: Data) {
        
        if let currentUser = firebaseAuth.currentUser {
            let profileImageRef = storage.child("profileImages/file.png").child(currentUser.uid)
            
            profileImageRef.putData(imageData) { storageData, error in
                guard error == nil else { return }
                self.isUploadingSuccess.onNext(true)
            }
        }
        
    }
    
    func fetchProfilePhoto() {
        //save download url
        if let currentUser = firebaseAuth.currentUser {
            let profileImageRef = storage.child("profileImages/file.png").child(currentUser.uid)
            
            profileImageRef.downloadURL { profileImageURL, error in
                guard let profileImageURL = profileImageURL, error == nil else { return }
                let urlString = profileImageURL.absoluteString
                self.isDownloadingURLSuccess.onNext(urlString)
            }
        }
        
    }
    
    
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
