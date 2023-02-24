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
    
    private let firebaseAuth = Auth.auth()
    private let storage = Storage.storage().reference()
    
    private let disposeBag = DisposeBag()
    
    var isDownloadingURLSuccess = PublishSubject<String>()
    
    
    //MARK: - Getting and setting User Profile Photo
    
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
    
    
    func fetchProviderProfilePhoto() {
        if let currentUserProviderPhoto = firebaseAuth.currentUser?.photoURL {
            let urlString = currentUserProviderPhoto.absoluteString
            self.isDownloadingURLSuccess.onNext(urlString)
        }
    }
    
    
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
}
