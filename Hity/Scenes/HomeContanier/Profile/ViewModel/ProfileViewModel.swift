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
    
    //MARK: - Constants

    private let firebaseAuth = Auth.auth()
    private let storage = Storage.storage().reference()
    
    
    //MARK: - Observable variables

    let isUploadingSuccess = PublishSubject<Bool>()
    let isDownloadingURLSuccess = PublishSubject<String>()
    let isSigningOutSuccess = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    let isFetchingUserDisplayName = PublishSubject<String>()
    
    
    //MARK: - Fetch User Profile Photo
    
    func fetchProfilePhoto() {
        //save download url
        if let currentUser = firebaseAuth.currentUser {
            let profileImageRef = storage.child("profileImages/file.png").child(currentUser.uid)
            profileImageRef.downloadURL { profileImageURL, error in
                if let _ = error {
                    // if user did not have photo in firebase storage
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
    
    
    //MARK: - Fetch User Display Name
    
    func fetchUserDisplayName() {
        if let currentUser = firebaseAuth.currentUser {
            if let userDisplayName = currentUser.displayName {
                self.isFetchingUserDisplayName.onNext(userDisplayName)
            } else {
                self.isFetchingUserDisplayName.onNext("Nameless User")
            }
            
        }
    }
    
    //MARK: - Upload Image Data To FirebaseStorage
    
    func uploadImageDataToFirebaseStorage(_ imageData: Data) {
        if let currentUser = firebaseAuth.currentUser {
            let profileImageRef = storage.child("profileImages/file.png").child(currentUser.uid)
            
            profileImageRef.putData(imageData) { storageData, error in
                guard error == nil else { return }
                self.isUploadingSuccess.onNext(true)
            }
        }
        
    }
    
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
