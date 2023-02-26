//
//  ChangeUsernamePopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import UIKit
import RxSwift

final class ChangeUsernamePopUpController: UIViewController {
    
    //MARK: - Constants
    
    let changeUsernamePopUpView = ChangeUsernamePopUpView()
    let changeUsernamePopUpViewModel = ChangeUsernamePopUpViewModel()
    
    //MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()
    
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
        addGestureRecognizerToView()
        createCallbacks()
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        tapGestureCallback()
        createViewModelCallbacks()
        createPopUPViewButtonCallbacks()
    }
    
    //MARK: - AddGestureRecocgnizer to View
    
    private func addGestureRecognizerToView() {
        changeUsernamePopUpView.emptyView.addGestureRecognizer(tapGesture)
    }
    
    private func tapGestureCallback() {
        tapGesture.rx.event.bind { [weak self] recognizer in
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
    }
    
    //MARK: - PopUpView Button callbacks
    
    private func createPopUPViewButtonCallbacks() {
        
        // Submit Button
        changeUsernamePopUpView.submitButton.rx.tap.subscribe(onNext: { [weak self] in
            if let username = self?.changeUsernamePopUpView.userNameTextField.text {
                if username.count > 0 {
                    self?.changeUsernamePopUpViewModel.changeUsername(username)
                } else {
                    self?.changeUsernamePopUpView.userNameTextField.attributedPlaceholder = NSAttributedString(
                        string: "*This field is required.",
                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                }
            }
        }).disposed(by: changeUsernamePopUpView.disposeBag)
        
                
    }
    
    
    //MARK: - ViewModel Callbacks
    
    private func createViewModelCallbacks() {
        
        changeUsernamePopUpViewModel.isChangingUsername.subscribe { [weak self] value in
            if value {
                self?.changeUsernamePopUpView.activityIndicator.startAnimating()
            } else {
                self?.changeUsernamePopUpView.activityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        
        changeUsernamePopUpViewModel.isChangingUsernameSuccess.subscribe { [weak self] isChanged in
            if isChanged {
                self?.changeUsernamePopUpView.viewModelCallbackLabel.textColor = .green
                self?.changeUsernamePopUpView.viewModelCallbackLabel.text = "Username has been changed."
            }
        }.disposed(by: disposeBag)
        
        changeUsernamePopUpViewModel.errorMsg.subscribe { [weak self] errorMsg in
            self?.changeUsernamePopUpView.viewModelCallbackLabel.textColor = .red
            self?.changeUsernamePopUpView.viewModelCallbackLabel.text = errorMsg
        }.disposed(by: disposeBag)
        
        
    }
    
    
}

//MARK: - ChangeUsernamePopUpView Configure

extension ChangeUsernamePopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        changeUsernamePopUpView.alpha = 0
        changeUsernamePopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            self?.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
            self.changeUsernamePopUpView.alpha = 1
            self.changeUsernamePopUpView.contentView.alpha = 1
            self.changeUsernamePopUpView.frame = CGRect(x: 0 , y: -Int(self.view.frame.height) / 2, width: Int(self.view.frame.width), height: Int(self.view.frame.height) / 2)
            
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [unowned self] in
            self.changeUsernamePopUpView.frame.origin.y = self.changeUsernamePopUpView.frame.height
            self.changeUsernamePopUpView.alpha = 0
            self.changeUsernamePopUpView.contentView.alpha = 0
            
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
        }
        
    }
}


//MARK: - View AddSubview / Constraints

extension ChangeUsernamePopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(changeUsernamePopUpView)
    }
    
    private func setupConstraints() {
        changeUsernamePopUpView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
}

