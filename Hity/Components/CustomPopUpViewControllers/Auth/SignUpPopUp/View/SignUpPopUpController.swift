//
//  SignUpPopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 22.02.2023.
//

import UIKit
import RxSwift

final class SignUpPopUpController: UIViewController {
    
    //MARK: - Constants
    
    private let signUpPopUpView = SignUpPopUpView()
    //    private let signUpPopUpViewModel = SignUpPopUpViewModel()
    
    //MARK: - Dispose Bag
    
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
        createCallbacks()
    }
    
    //MARK: - CreateCallbacks
    
    private func createCallbacks() {
        createContentViewButtonCallbacks()
    }
    
    
    //MARK: - Creating SignUpPopUpView's ContentView Button Callbacks
    
    private func createContentViewButtonCallbacks() {
        signUpPopUpView.okButton.rx.tap.bind { [weak self] in
            self?.hidePopUpView({
                let controller = SignInController()
                self?.navigationController?.pushViewController(controller, animated: true)
            })
        }.disposed(by: signUpPopUpView.disposeBag)
    }
    
    
}

//MARK: - SignUpPopUpView Configure

extension SignUpPopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        signUpPopUpView.backgroundColor = .black.withAlphaComponent(0.6)
        signUpPopUpView.alpha = 0
        signUpPopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            // show popup view
            self?.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            self?.signUpPopUpView.alpha = 1
            self?.signUpPopUpView.contentView.alpha = 1
        }
    }
    
    private func hidePopUpView(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.signUpPopUpView.alpha = 0
            self?.signUpPopUpView.contentView.alpha = 0
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
            completion()
        }
        
        
    }
}


//MARK: - View AddSubview / Constraints

extension SignUpPopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(signUpPopUpView)
    }
    
    //MARK: - SetupConstraints
    
    private func setupConstraints() {
        signUpPopUpViewConstraints()
    }
    
    private func signUpPopUpViewConstraints() {
        signUpPopUpView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
}
