//
//  SignInController.swift
//  Hity
//
//  Created by Ekrem Alkan on 10.02.2023.
//

import UIKit
import RxSwift
import AuthenticationServices
import FirebaseAuth
import FBSDKLoginKit


final class SignInController: UIViewController {
    
    
    //MARK: - Properties
    
    private let signInView = SignInView()
    private let signInViewModel = SignInViewModel()
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Apple Sign In currentNonce
    
    fileprivate var currentNonce: String?


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
        signInView.appleSignInButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.startSignInWithAppleFlow()
        }).disposed(by: signInView.disposeBag)
        
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


//MARK: - Apple Sign In  Flow(work only apple developer account because have to enable SignInWithApple )

extension SignInController {
    
    private func startSignInWithAppleFlow() {
        let nonce = RandomNonceString.shared.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = Sha256.shared.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

//MARK: - ASAuthorizationControllerDelegate

extension SignInController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else { fatalError("Invalid state: A login callback was received, but no login request was sent.") }
            guard let appleIDToken = appleIDCredential.identityToken else { print("Unable to fetch identity token"); return}
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {  print("Unable to serialize token string from data: \(appleIDToken.debugDescription)"); return}
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            signInViewModel.signInWithProvider(credential)
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        print("have to apple developer membership for apple sign in work ")
    }
    
    
}

//MARK: - ASAuthorizationControllerPresentationContextProviding

extension SignInController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}






