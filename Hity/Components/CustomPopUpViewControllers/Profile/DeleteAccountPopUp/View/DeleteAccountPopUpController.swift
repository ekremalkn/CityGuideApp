//
//  DeleteAccountPopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import UIKit
import RxSwift

final class DeleteAccountPopUpController: UIViewController {
    
    //MARK: - Constants
    
    private let deleteAccountPopUpView = DeleteAccountPopUpView()
    private let deleteAccountPopUpViewModel = DeleteAccountPopUpViewModel()
    
    //MARK: - Dispose Bag
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Tap Gesture
    
    let tapGesture = UITapGestureRecognizer()
    
    //MARK: - Init Methods
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        addGestureRecognizerToView()
        createCallbacks()
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        createViewModelCallbacks()
        createPopUpViewButtonCallbacks()
        tapGestureCallback()
    }
    
    //MARK: - AddGestureRecocgnizer to View
    
    private func addGestureRecognizerToView() {
        deleteAccountPopUpView.emptyView.addGestureRecognizer(tapGesture)
    }
    
    
    //MARK: - Create TapGestureCallback
    
    private func tapGestureCallback() {
        tapGesture.rx.event.subscribe { [weak self] recognizer in
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
    }
    
    
    //MARK: - PopUpView ButtonCallbacks
    
    private func createPopUpViewButtonCallbacks() {
        
        deleteAccountPopUpView.deleteButton.rx.tap.subscribe(onNext: { [weak self] in
            if let email = self?.deleteAccountPopUpView.emailTextField.text {
                if email.count > 0 {
                    self?.deleteAccountPopUpViewModel.checkAreEmailsMatching(email)
                } else {
                    self?.deleteAccountPopUpView.viewModelCallbackLabel.text = "This field is required."
                }
            } else {
                // textfield nil
            }
            
            // emaili kontrol et eğer doğruysa hesabı sil
        }).disposed(by: deleteAccountPopUpView.disposeBag)
    }
    
}

//MARK: - ViewModel Callbacks

extension DeleteAccountPopUpController {
    
    private func createViewModelCallbacks() {
        
        deleteAccountPopUpViewModel.isCheckingEmails.subscribe { [weak self] value in
            if value {
                self?.deleteAccountPopUpView.activityIndicator.startAnimating()
            } else {
                self?.deleteAccountPopUpView.activityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        
        deleteAccountPopUpViewModel.isCheckingEmailsSuccess.subscribe { [weak self] _ in
            self?.deleteAccountPopUpViewModel.deleteAccount()
        }.disposed(by: disposeBag)
        
        
        deleteAccountPopUpViewModel.isDeletingAccount.subscribe { [weak self] value in
            if value {
                self?.deleteAccountPopUpView.activityIndicator.color = .red
                self?.deleteAccountPopUpView.activityIndicator.startAnimating()
            } else {
                self?.deleteAccountPopUpView.activityIndicator.color = .red
                self?.deleteAccountPopUpView.activityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        deleteAccountPopUpViewModel.isDeletingAccountSuccess.subscribe { [weak self] _ in
            let signInVC = SignInController()
            signInVC.modalPresentationStyle = .fullScreen
            self?.present(signInVC, animated: false)
        }.disposed(by: disposeBag)
        
        deleteAccountPopUpViewModel.errorMsg.subscribe { [weak self] errorMsg in
            self?.deleteAccountPopUpView.viewModelCallbackLabel.text = errorMsg
        }.disposed(by: disposeBag)
    }
    
    
}



//MARK: - DeleteAccountPopUpView Configure

extension DeleteAccountPopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        deleteAccountPopUpView.alpha = 0
        deleteAccountPopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            self?.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
            self.deleteAccountPopUpView.alpha = 1
            self.deleteAccountPopUpView.contentView.alpha = 1
            self.deleteAccountPopUpView.frame = CGRect(x: 0 , y: -Int(self.view.frame.height) / 2, width: Int(self.view.frame.width), height: Int(self.view.frame.height) / 2)
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [unowned self] in
            self.deleteAccountPopUpView.frame.origin.y = self.deleteAccountPopUpView.frame.height
            self.deleteAccountPopUpView.alpha = 0
            self.deleteAccountPopUpView.contentView.alpha = 0
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
        }
        
    }
}


//MARK: - View AddSubview / Constraints


extension DeleteAccountPopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(deleteAccountPopUpView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        deleteAccountPopUpView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(view)
        }
    }
    
    
}
