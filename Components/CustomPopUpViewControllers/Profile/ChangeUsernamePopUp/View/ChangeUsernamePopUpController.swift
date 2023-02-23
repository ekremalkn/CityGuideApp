//
//  ChangeUsernamePopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import UIKit
import RxSwift

final class ChangeUsernamePopUpController: UIViewController {

    //MARK: - Properties
    
    private let changeUsernamePopUpView = ChangeUsernamePopUpView()
    private let changeUsernamePopUpViewModel = ChangeUsernamePopUpVieModel()
    private let disposeBag = DisposeBag()
    
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
        changeUsernamePopUpView.emptyView.addGestureRecognizer(tapGesture)
        tapGestureCallback()
        createViewModelCallbacks()
        createPopUPViewButtonCallbacks()
        
    }

    private func tapGestureCallback() {
        tapGesture.rx.event.bind { [weak self] recognizer in
            self?.hidePopUpView()
            print("dokundun")
        }.disposed(by: disposeBag)
    }
    
    //MARK: - PopUpView Button callbacks
    
    private func createPopUPViewButtonCallbacks() {
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
        }).disposed(by: disposeBag)
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
        self.changeUsernamePopUpView.alpha = 0
        self.changeUsernamePopUpView.contentView.alpha = 0
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

