//
//  UserDataViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 20.02.2023.
//

import RxSwift
import FirebaseAuth
import FirebaseStorage


final class UserDataViewModel {
    
    //MARK: - Constants

    private let firebaseAuth = Auth.auth()
    private let storage = Storage.storage().reference()
    
    //MARK: - Observable Variables

    let isDownloadingURLSuccess = PublishSubject<String>()
    
    
    //MARK: - Fetch User Profile Photo

    func fetchProfilePhoto() {
        //save download url
        if let currentUser = firebaseAuth.currentUser {
            let profileImageRef = storage.child("profileImages/file.png").child(currentUser.uid)
            profileImageRef.downloadURL { profileImageURL, error in
                if let _ = error {
                    //kullanıcı firebase storage fotoğraf yüklememiştir
                    self.checkUserIsLoginThroughProvider()
                }
                guard let profileImageURL = profileImageURL, error == nil else { return }
                let urlString = profileImageURL.absoluteString
                self.isDownloadingURLSuccess.onNext(urlString)
            }
        }
        
    }
    
    //MARK: - Check User Provider Type of Login

    func checkUserIsLoginThroughProvider() {
        if let providerData = firebaseAuth.currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case FacebookAuthProviderID:
                    self.fetchProviderProfilePhoto()
                    print("facebook ile girildi")
                case GoogleAuthProviderID:
                    print("google ile girildi")
                    self.fetchProviderProfilePhoto()
                default:
                    break
                }
            }
        }
    }
    
    //MARK: - Fetch Provider Profile Photo
    
    //If signed with using Provider and did not have Profile photo in firebase storage
    func fetchProviderProfilePhoto() {
        if let currentUserProviderPhoto = firebaseAuth.currentUser?.photoURL {
            let urlString = currentUserProviderPhoto.absoluteString
            self.isDownloadingURLSuccess.onNext(urlString)
        }
    }
    

}
