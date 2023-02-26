//
//  ChangeEmailPopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import UIKit
import RxSwift

final class ChangeEmailPopUpController: UIViewController {
    
    
    //MARK: - Constants
    
    private let changeEmailPopUpView = ChangeEmailPopUpView()
    private let changeEmailPopUpViewModel = ChangeEmailPopUpViewModel()
    
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
    
    
    //MARK: - Life Cycle Methods
    
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
        changeEmailPopUpViewModel.fetchEmail()
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        tapGestureCallback()
        createViewModelCallbacks()
        createPopUpViewButtonCallbacks()
    }
    
    //MARK: - AddGestureRecocgnizer to View
    
    private func addGestureRecognizerToView() {
        changeEmailPopUpView.emptyView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - TapGesture Callback
    
    private func tapGestureCallback() {
        tapGesture.rx.event.bind { [weak self] recognizer in
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
    }
    
    
    
    //MARK: - PopUpView button callbacks
    
    private func createPopUpViewButtonCallbacks() {
        changeEmailPopUpView.submitButton.rx.tap.subscribe(onNext: { [weak self] in
            if let newEmail = self?.changeEmailPopUpView.newEmailTextField.text, let confirmedNewEmail = self?.changeEmailPopUpView.confirmNewEmailTextField.text {
                if newEmail == confirmedNewEmail {
                    self?.changeEmailPopUpViewModel.changeEmail(newEmail)
                } else {
                    self?.changeEmailPopUpView.viewModelCallbackLabel.textColor = .red
                    self?.changeEmailPopUpView.viewModelCallbackLabel.text = "New emails do not match."
                }
            }
            
        }).disposed(by: changeEmailPopUpView.disposeBag)
        
        changeEmailPopUpView.logOutButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.changeEmailPopUpViewModel.signOut()
        }).disposed(by: changeEmailPopUpView.disposeBag)
    }
    
    //MARK: - ViewModel callbacks
    
    private func createViewModelCallbacks() {
        changeEmailPopUpViewModel.isChangingEmailSuccess.subscribe { [weak self] isChanged in
            if isChanged {
                self?.changeEmailPopUpView.emptyView.isUserInteractionEnabled = false
                self?.changeEmailPopUpView.viewModelCallbackLabel.textColor = .green
                self?.changeEmailPopUpView.viewModelCallbackLabel.text = "Email has been changed. Please please log out and log in again."
                self?.changeEmailPopUpView.submitButton.isHidden = true
                self?.changeEmailPopUpView.logOutButton.isHidden = false
            }
        }.disposed(by: disposeBag)
        
        
        changeEmailPopUpViewModel.isChangingEmail.subscribe { [weak self] value in
            if value {
                self?.changeEmailPopUpView.activityIndicator.startAnimating()
            } else {
                self?.changeEmailPopUpView.activityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        changeEmailPopUpViewModel.errorMsg.subscribe { [weak self] errorMsg in
            self?.changeEmailPopUpView.viewModelCallbackLabel.textColor = .red
            self?.changeEmailPopUpView.viewModelCallbackLabel.text = errorMsg
        }.disposed(by: disposeBag)
        
        
        changeEmailPopUpViewModel.isFetchingEmailSuccess.subscribe { [weak self] email in
            self?.changeEmailPopUpView.currentEmailTextField.text = email
        }.disposed(by: disposeBag)
        
        changeEmailPopUpViewModel.isSigningOut.subscribe { [weak self] value in
            if value {
                self?.changeEmailPopUpView.activityIndicator.startAnimating()
            } else {
                self?.changeEmailPopUpView.activityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        changeEmailPopUpViewModel.isSigningOutSuccess.subscribe { [weak self] isSignedOut in
            if isSignedOut {
                let signInVC = SignInController()
                signInVC.modalPresentationStyle = .fullScreen
                self?.present(signInVC, animated: true)
            }
        }.disposed(by: disposeBag)
        
    }
    
    
}

//MARK: - ChangeEmailPopUpView Configure

extension ChangeEmailPopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        self.changeEmailPopUpView.alpha = 0
        self.changeEmailPopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            self?.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            [unowned self] in
            self.changeEmailPopUpView.alpha = 1
            self.changeEmailPopUpView.contentView.alpha = 1
            self.changeEmailPopUpView.frame = CGRect(x: 0 , y: -Int(self.view.frame.height) / 2, width: Int(self.view.frame.width), height: Int(self.view.frame.height) / 2)
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [unowned self] in
            self.changeEmailPopUpView.frame.origin.y = self.changeEmailPopUpView.frame.height
            self.changeEmailPopUpView.alpha = 0
            self.changeEmailPopUpView.contentView.alpha = 0
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
        }
        
    }
}

//MARK: - View Addsubview / Constraints

extension ChangeEmailPopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(changeEmailPopUpView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        changeEmailPopUpView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
    
}

