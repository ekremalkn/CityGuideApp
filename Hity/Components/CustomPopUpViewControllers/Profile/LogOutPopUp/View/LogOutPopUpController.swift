//
//  LogOutPopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 22.02.2023.
//

import UIKit
import RxSwift

final class LogOutPopUpController: UIViewController {
    
    
    //MARK: - Constants
    
    private let logOutPopUpView = LogOutPopUpView()
    private let logOutPopUpViewModel = LogOutPopUpViewModel()
    
    //MARK: - Dispose Bag
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Init methods
    
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
        createCallbacks()
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        createContentViewButtonCallbacks()
        createViewModelCallbacks()
    }
    
    //MARK: - PopUpView ButtonCallbacks
    
    private func createContentViewButtonCallbacks() {
        logOutPopUpView.yesButton.rx.tap.bind { [weak self] in
            self?.logOutPopUpViewModel.signOut()
        }.disposed(by: disposeBag)
        
        logOutPopUpView.noButton.rx.tap.bind { [weak self] in
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Creating LogOutPopUpViewModel Callbacks
    
    private func createViewModelCallbacks() {
        logOutPopUpViewModel.isSigningOutSuccess.subscribe { [weak self] isSignOut in
            if isSignOut {
                let signInVC = SignInController()
                signInVC.modalPresentationStyle = .fullScreen
                self?.present(signInVC, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
}

//MARK: - LogOutPopUpView Configure

extension LogOutPopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        self.logOutPopUpView.backgroundColor = .black.withAlphaComponent(0.6)
        self.logOutPopUpView.alpha = 0
        self.logOutPopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) {
            self.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.logOutPopUpView.alpha = 1
            self.logOutPopUpView.contentView.alpha = 1
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.logOutPopUpView.alpha = 0
            self?.logOutPopUpView.contentView.alpha = 0
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
            
        }
        
    }
}



//MARK: - View AddSubview / Constraints

extension LogOutPopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(logOutPopUpView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        logOutPopUpView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
    
    
}
