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
        configureNavBar()
        createCallbacks()
    }
    
    private func configureNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Sign In", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        signInViewButtonCallbacks()
        signInViewModelCallbacks()
        didGetRequest()
    }
    
}

//MARK: - Create SignInView Button Callbacks

extension SignInController {
    
    private func signInViewButtonCallbacks() {
        
        // Sign In Button
        signInView.signInButton.rx.tap.subscribe(onNext: { [weak self] in
            if let email = self?.signInView.emailTextField.text, let password = self?.signInView.passwordTextField.text {
                self?.signInViewModel.signInWithEmail(email, password)
            } else {
                self?.signInViewModel.errorMsg.onNext("Fields cannot be left blank.")
            }
        }).disposed(by: signInView.disposeBag)
        
        // Password Eye Button
        signInView.passwordEyeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.signInView.passwordEyeButtonToggle()
        }).disposed(by: signInView.disposeBag)
        
        // Forgot Password Button
        signInView.forgotPasswordButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = ResetPasswordController()
            controller.presentPopUpController(self)
        }).disposed(by: signInView.disposeBag)
        
        // Google Sign In Button
        signInView.googleSignInBtn.rx.tap.subscribe(onNext: { [unowned self] in
            self.signInViewModel.getGoogleCredential(self)
        }).disposed(by: signInView.disposeBag)
        
        // Facebook Sign In Button
        signInView.facebookSignInBtn.rx.tap.subscribe(onNext: { [unowned self] in
            self.signInViewModel.getFacebookToken(self)
        }).disposed(by: signInView.disposeBag)
        
        // Apple Sign In Button
        /// appleIDProviderRequest()
        ////bakılcak
        
        // Sign Up Button
        
        signInView.signUpButton.rx.tap.subscribe(onNext: { [weak self] in
            let controller = SignUpController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: signInView.disposeBag)
        
    }
}

//MARK: - Create SignInViewModel Callbacks

extension SignInController {
    private func signInViewModelCallbacks () {
        
        // Getted SignIn Credential
        signInViewModel.credential.subscribe { [weak self] credential in
            self?.signInViewModel.signInWithProvider(credential)
        }.disposed(by: disposeBag)
        
        // Check email verification
        signInViewModel.isEmailVerification.subscribe { [unowned self] isVerified in
            if isVerified {
                let tabBar = MainTabBarController()
                tabBar.modalPresentationStyle = .fullScreen
                self.present(tabBar, animated: true)
            } else {
                let popUpController = SignInPopUpController()
                popUpController.presentPopUpController(self)
                // ekrana pop up view ver ve email adresinizi doğrulayın çıksın. altına button ekle ve basınca email adresi doğrulama linki gönder
            }
        }.disposed(by: disposeBag)
        
        // SignIn Loading
        signInViewModel.isLoading.subscribe { [weak self] value in
            if value {
                self?.signInView.activityIndicator.startAnimating()
            } else {
                self?.signInView.activityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        // SignIn Success
        signInViewModel.isSuccess.subscribe { [weak self] _ in
            self?.signInViewModel.checkEmailVerification()
            
        }.disposed(by: disposeBag)
        
        // SignIn Error
        signInViewModel.errorMsg.subscribe { [weak self] error in
            self?.signInView.signInErrorLabel.text = error
        }.disposed(by: disposeBag)
        
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






