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
    
    //MARK: - Gettable Properties
    
    var email: String {
        guard let email = signInView.emailTextField.text else { return ""}
        return email
    }
    
    var password: String {
        guard let password = signInView.passwordTextField.text else { return ""}
        return password
    }
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = signInView
        signInView.interface = self
        configureSignInMethods()
    }
    
    //MARK: - Section Heading
    
    private func configureSignInMethods() {
        didGetCredential()
        didGetRequest()
        setupFacebookSignInButton()
        createCallbacks()
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
    
    func signUpButtonTapped(_ view: SignInView) {
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func signInButtonTapped(_ view: SignInView) {
        signInViewModel.signInWithEmail(email, password)
    }
    
    
}

//MARK: - Configure SignIn

extension SignInController {
    func didGetCredential() {
        signInViewModel.credential.subscribe { [weak self] credential in
            self?.signInViewModel.signInWithProvider(credential)
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

//MARK: - Creating Sign In Callbacks

extension SignInController {
    private func createCallbacks (){
        
        // success
        signInViewModel.isSuccess.subscribe { [weak self] _ in
            let tabBar = MainTabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            self?.present(tabBar, animated: true)
        }.disposed(by: disposeBag)
        
        // errors
        signInViewModel.errorMsg.subscribe { error in
            print("errror agaaa \(error)")
        }.disposed(by: disposeBag)
        
    }
}




