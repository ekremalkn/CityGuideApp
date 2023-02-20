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
}
