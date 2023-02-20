//
//  ResetPasswordController.swift
//  Hity
//
//  Created by Ekrem Alkan on 20.02.2023.
//

import UIKit
import RxSwift

final class ResetPasswordController: UIViewController {

    
    //MARK: - Properties
    
    private let resetPasswordView = ResetPasswordView()
    private let resetPasswordViewModel = ResetPasswordViewModel()

    private let disposeBag = DisposeBag()

    
    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = resetPasswordView
        createCallbacks()
    }

    private func createCallbacks() {
        createResetPasswordViewButtonsCallbacks()
        createResetPasswordViewModelCallbacks()
    }
    
    //MARK: - Creating ResetPassword View Buttons Callbacks
    
    private func createResetPasswordViewButtonsCallbacks() {
        
        resetPasswordView.submitButton.rx.tap.subscribe(onNext: { [weak self] in
            if let email = self?.resetPasswordView.emailTextField.text {
                self?.resetPasswordViewModel.sendPasswordResetEmail(email)
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Creating ResetPassword ViewModel Callbacks
    
    private func createResetPasswordViewModelCallbacks() {
        resetPasswordViewModel.isSendingResetEmailSuccess.subscribe(onNext: { _ in
            print("reset emaili gönderildi")
            
        }).disposed(by: disposeBag)
    }



}
