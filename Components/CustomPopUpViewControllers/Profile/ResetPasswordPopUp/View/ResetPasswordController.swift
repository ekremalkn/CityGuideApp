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
    
    let tapGesture = UITapGestureRecognizer()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        addSubview()
        setupConstraints()
        appearanceWhenViewDidLoad()
        self.resetPasswordView.emptyView.addGestureRecognizer(tapGesture)
        createCallbacks()
    }

    private func createCallbacks() {
        createResetPasswordViewButtonsCallbacks()
        createResetPasswordViewModelCallbacks()
        tapGestureCallback()
    }
    
    //MARK: - TapGesture Callback
    
    private func tapGestureCallback() {
        tapGesture.rx.event.subscribe { [weak self] recognizer in
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
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
        
        resetPasswordViewModel.isSendingResetEmail.subscribe { [weak self] value in
            if value {
                self?.resetPasswordView.activityIndicator.startAnimating()
            } else {
                self?.resetPasswordView.activityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
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

//MARK: - Configure ResetPasswordView

extension ResetPasswordController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        self.resetPasswordView.alpha = 0
        self.resetPasswordView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            self?.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
            self.resetPasswordView.alpha = 1
            self.resetPasswordView.contentView.alpha = 1
            self.resetPasswordView.frame = CGRect(x: 0 , y: -Int(self.view.frame.height) / 2, width: Int(self.view.frame.width), height: Int(self.view.frame.height) / 2)
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.resetPasswordView.frame.origin.y = self.resetPasswordView.frame.height
            self.resetPasswordView.alpha = 0
            self.resetPasswordView.contentView.alpha = 0
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
        }

    }
}

//MARK: - View Addsubview / Constraints

extension ResetPasswordController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(resetPasswordView)
    }
    
    //MARK: - SetupConstraints
    
    private func setupConstraints() {
        resetPasswordView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(view)
        }
    }


}

