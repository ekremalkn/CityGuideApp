//
//  SignInViewModel.swift
//  Hity
//
//  Created by Ekrem Alkan on 10.02.2023.
//


import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import AuthenticationServices
import FBSDKLoginKit
import RxSwift


final class SignInViewModel {
    
    private let googleSignInManager = GIDSignIn.sharedInstance
    
    let credential = PublishSubject<AuthCredential>()
    let request = PublishSubject<ASAuthorizationAppleIDRequest>()
    fileprivate var currentNonce: String?
    
    
    func signIn(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let _ = authResult else { return }
            
            print("giriş başarılı")
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signin out: %@", signOutError)
        }
        
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

//MARK: - SignInWithApple Methods

extension SignInViewModel {
    
    func handleSignInWithAppleRequest() {
        let nonce = RandomNonceString.shared.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = Sha256.shared.sha256(nonce)
        self.request.onNext(request)
    }
    
    func didCompleteWithAuthorization(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else { fatalError("Invalid state: A login callback was received, but no login request was sent.") }
            guard let appleIDToken = appleIDCredential.identityToken else { print("Unable to fetch identity token"); return}
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {  print("Unable to serialize token string from data: \(appleIDToken.debugDescription)"); return}
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            self.credential.onNext(credential)
        }
     
    }
    
}



