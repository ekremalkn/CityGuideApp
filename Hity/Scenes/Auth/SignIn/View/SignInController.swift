//
//  SignInController.swift
//  Hity
//
//  Created by Ekrem Alkan on 10.02.2023.
//

import UIKit
import RxSwift
import AuthenticationServices
import FBSDKLoginKit

final class SignInController: UIViewController {

    
    //MARK: - Properties
    
    private let signInView = SignInView()
    private let signInViewModel = SignInViewModel()
    private let disposeBag = DisposeBag()


    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        

    }
    
    //MARK: - Configure ViewController

    private func configureViewController() {
        view = signInView
        signInView.interface = self
        didGetCredential()
        didGetRequest()
        setupFacebookSignInButton()
    }

}

//MARK: - SignInViewInterface

extension SignInController: SignInViewInterface {


    func googleSignInButtonTapped(_ view: SignInView) {
        signInViewModel.getGoogleCredential(self)
    }
    
    func appleSignInButtonTapped(_ view: SignInView) {
        appleIDProviderRequest()
    }
   
    func facebookSignInButttonTapped(_ view: SignInView) {
    
    }
    
    
}

//MARK: - Configure SignIn

extension SignInController {
    func didGetCredential() {
        signInViewModel.credential.subscribe { [weak self] credential in
            self?.signInViewModel.signIn(credential)
        }.disposed(by: disposeBag)
    }
}

//MARK: - SignInWithFacebook Methods

extension SignInController: LoginButtonDelegate  {
    
    func setupFacebookSignInButton() {
        signInView.facebookSignInButton.delegate = self
    }
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
          }
        
        guard let result = result else { return }
        if let tokenString = result.token?.tokenString {
            signInViewModel.getFacebookCredential(tokenString)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        signInViewModel.signOut()
    }
   
}


//MARK: - SignInWithApple Methods

extension SignInController {
    private func  appleIDProviderRequest() {
        signInViewModel.handleSignInWithAppleRequest()
    }
    
    private func didGetRequest() {
        signInViewModel.request.subscribe { [weak self] request in
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }.disposed(by: disposeBag)
    }
    
}

//MARK: - ASAuthorizationControllerDelegate

extension SignInController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        signInViewModel.didCompleteWithAuthorization(authorization)
       
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }

    
}

//MARK: - ASAuthorizationControllerPresentationContextProviding

extension SignInController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}


