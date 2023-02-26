//
//  SignInViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 10.02.2023.
//


import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit
import RxSwift
import RxCocoa


final class SignInViewModel {
    
    //MARK: - Google SignIn Manager
    private let googleSignInManager = GIDSignIn.sharedInstance
    
    let credential = PublishSubject<AuthCredential>()
//    let request = PublishSubject<ASAuthorizationAppleIDRequest>()
    
    // Fields that bind to our view's
    
    let isSuccess = PublishSubject<Bool>()
    let isLoading = PublishSubject<Bool>()
    let isEmailVerification = PublishSubject<Bool>()
    let errorMsg = PublishSubject<String>()
    
    let isDatabaseCreatingSuccess = PublishSubject<Bool>()
    let isDatabaseCreating = PublishSubject<Bool>()
    
    //MARK: - FirestoreDatabase Constants
    private let database = Firestore.firestore()
    private let firebaseAuth = Auth.auth()
    
    //MARK: - Sign In With Provider
    
    func signInWithProvider(_ credential: AuthCredential) {
        
        self.isLoading.onNext(true)
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, authError in
            
            if let authError = authError {
                self?.isLoading.onNext(false)
                self?.errorMsg.onNext(authError.localizedDescription)
                return
            }
            guard let authResult = authResult else { return }
            self?.isLoading.onNext(false)
            self?.isSuccess.onNext(true)
            if let username = authResult.user.displayName {
                self?.createDatabaseForUser(authResult, username)
            }
        }
        
    }
    
    //MARK: - Check Email Verification
    
    func checkEmailVerification() {
        
        if let currentUser = firebaseAuth.currentUser {
            if currentUser.isEmailVerified {
                self.isEmailVerification.onNext(true)
                // reset password buttonunu etkinleştir
                // email verification buttonunu gizle
            } else {
                self.isEmailVerification.onNext(false)
                // ekrana pop up view ver ve email adresinizi doğrulayın çıksın. altına button ekle ve basınca email adresi doğrulama linki gönder
                // reset password buttonunu disable yap
                // email verification buttonunu göster
            }
        }
    }
    
    //MARK: - Sign In With Email
    
    func signInWithEmail(_ email: String, _ password: String) {
        
        self.isLoading.onNext(true)
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] authResult, authError in
            if let authError = authError {
                self?.isLoading.onNext(false)
                self?.errorMsg.onNext(authError.localizedDescription)
                return
            } else {
                self?.isLoading.onNext(false)
                self?.isSuccess.onNext(true)
            }
            
        }
    }
    
    //MARK: - Sign Out
    
    func signOut() {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signin out: %@", signOutError)
        }
        
    }
    
    
}

//MARK: - Create FirestoreDatabase

extension SignInViewModel {
    
    private func createDatabaseForUser(_ authResult: AuthDataResult, _ username: String) {
        self.isDatabaseCreating.onNext(true)
        
        self.changeUserDisplayName(username)
        
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
    
}

//MARK: - SignInWithGoogle Methods

extension SignInViewModel {
    
    func getGoogleCredential(_ controller: UIViewController) {
        googleSignInManager.signIn(withPresenting: controller) { [weak self] userResult, error in
            
            if let error = error {
                self?.credential.onError(error)
                return
            }
            
            guard let userResult = userResult else { return }
            if let idToken = userResult.user.idToken?.tokenString {
                let accessToken = userResult.user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                self?.credential.onNext(credential)
            }
            
        }
    }
}

//MARK: - SignInWithFacebook Methods

extension SignInViewModel {
    
    func getFacebookToken(_ sender: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: sender) { [weak self] result, error in
            if let error = error {
                self?.errorMsg.onNext(error.localizedDescription)
            } else if let result = result, result.isCancelled {
                // cancelled
            } else {
                // logged in
                if let tokenString = result?.token?.tokenString {
                    self?.getFacebookCredential(tokenString)
                }
            }
        }
    }
    
    func getFacebookCredential(_ tokenString: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
        self.signInWithProvider(credential)
    }
}




