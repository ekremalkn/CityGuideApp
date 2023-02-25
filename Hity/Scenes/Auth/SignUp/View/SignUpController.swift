//
//  SignUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 11.02.2023.
//

import UIKit
import RxSwift

final class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    private let signUpView = SignUpView()
    private let signUpViewModel = SignUpViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = signUpView
        createCallbacks()
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        signUpViewButtonCallbacks()
        signUpViewModelCallbacks()
    }
    
}

//MARK: - Create SigUpView Button Callbacks

extension SignUpController {
    
    private func signUpViewButtonCallbacks() {
        
        // Password Eye Button
        signUpView.passwordEyeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.signUpView.passwordEyeButtonToggle()
        }).disposed(by: signUpView.disposeBag)
        
        // Sign Up Button
        signUpView.signUpButton.rx.tap.subscribe(onNext: { [weak self] in
            if let username = self?.signUpView.userNameTextField.text, let email = self?.signUpView.emailTextField.text, let password = self?.signUpView.passwordTextField.text {
                self?.signUpViewModel.signUp(username, email, password)
            } else {
                self?.signUpViewModel.errorMsg.onNext("Fields cannot be left blank.")
            }
            
        }).disposed(by: signUpView.disposeBag)
    }
}

//MARK: - Create SignUpViewModel Callbacks

extension SignUpController {
    
    func signUpViewModelCallbacks() {
        
        // Sign Up Loading
        signUpViewModel.isAccCreating.subscribe(onNext: { [weak self] isAccCreated in
            if isAccCreated {
                self?.signUpView.activityIndicator.startAnimating()
            } else {
                self?.signUpView.activityIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        // Sign Up Success
        signUpViewModel.isAccCreatingSuccess.subscribe(onNext: { [unowned self] _ in
            let controller = SignUpPopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: disposeBag)
        
        // Create Database Success
        signUpViewModel.isDatabaseCreatingSuccess.subscribe(onNext: { _ in
            print("Database has been created")
        }).disposed(by: disposeBag)
        
        // Sign Up Error
        signUpViewModel.errorMsg.subscribe(onNext: { [weak self] errorMsg in
            self?.signUpView.signUpErrorLabel.text = errorMsg
        }).disposed(by: disposeBag)
    }
    
}




