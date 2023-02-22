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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetPasswordViewModel.getUserEmail()
    }
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
        resetPasswordViewModel.isSendingResetEmailSuccess.subscribe(onNext: { [weak self] isSend in
            if isSend {
                self?.resetPasswordView.submitCallbackLabel.textColor = .green
                self?.resetPasswordView.submitCallbackLabel.text = "Password reset request was sent successfully."
            }
            
        }).disposed(by: disposeBag)
        
        
        resetPasswordViewModel.errorMsg.subscribe { [weak self] errorMsg in
            self?.resetPasswordView.submitCallbackLabel.textColor = .red
            self?.resetPasswordView.submitCallbackLabel.text = errorMsg
        }.disposed(by: disposeBag)
        
        resetPasswordViewModel.isEmailGettingSuccess.subscribe { [weak self] email in
            self?.resetPasswordView.emailTextField.text = email
            self?.resetPasswordView.subTitleLabel.text = ""
        }.disposed(by: disposeBag)
        
        resetPasswordViewModel.isEmailGettingUnsuccessful.subscribe { [weak self] _ in
            self?.resetPasswordView.emailTextField.isUserInteractionEnabled = true
        }.disposed(by: disposeBag)
        
        
    }
    
        



}
