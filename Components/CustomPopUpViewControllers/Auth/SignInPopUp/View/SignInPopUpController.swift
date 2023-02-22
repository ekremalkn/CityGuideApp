//
//  SignInPopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 22.02.2023.
//

import UIKit
import RxSwift

final class SignInPopUpController: UIViewController {

    //MARK: - Properties
    
    private let signInPopUpView = SignInPopUpView()
    private let signInPopUpViewModel = SignInPopUpViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Init Methods
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        addSubview()
        setupConstraints()
        appearanceWhenViewDidLoad()
        createContentViewButtonCallbacks()
        createViewModelCallbacks()
    }

    //MARK: - Creating SignInPopUpView's ContentView Button Callbacks
    
    private func createContentViewButtonCallbacks() {
        self.signInPopUpView.sendButton.rx.tap.bind(onNext: { [weak self] in
            if let sendButtonTitle = self?.signInPopUpView.sendButton.titleLabel?.text {
                if sendButtonTitle == "Cancel" {
                    self?.hidePopUpView()
                } else {
                    self?.signInPopUpViewModel.sendEmailVerificationLink()
                }
            }
           
        }).disposed(by: disposeBag)
        

    }
    
    //MARK: - Creating SingInPopUpViewModel Callbacks
    
    private func createViewModelCallbacks() {
        signInPopUpViewModel.isSendEmailSuccess.subscribe { [weak self] value in
            self?.signInPopUpView.accordingToEmailVerification(value)
        }.disposed(by: disposeBag)
        
        signInPopUpViewModel.isSendingEmail.subscribe { [weak self] value in
            if value {
                self?.signInPopUpView.activityIndicator.startAnimating()
            } else {
                self?.signInPopUpView.activityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
    }


}

//MARK: - SignInPopUpView Configure

extension SignInPopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        self.signInPopUpView.backgroundColor = .black.withAlphaComponent(0.6)
        self.signInPopUpView.alpha = 0
        self.signInPopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) {
            self.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.signInPopUpView.alpha = 1
            self.signInPopUpView.contentView.alpha = 1
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.signInPopUpView.alpha = 0
            self.signInPopUpView.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
}

//MARK: - View AddSubview / Constraints

extension SignInPopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(signInPopUpView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        signInPopUpViewConstraints()
    }

    private func signInPopUpViewConstraints() {
        signInPopUpView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }

}

