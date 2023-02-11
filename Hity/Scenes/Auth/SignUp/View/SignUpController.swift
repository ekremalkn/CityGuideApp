//
//  SignUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 11.02.2023.
//

import UIKit

final class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    private let signUpView = SignUpView()
    private let signUpViewModel = SignUpViewModel()
    
    //MARK: - Gettable Properties
    
    var username: String {
        guard let username = signUpView.userNameTextField.text else { return ""}
        return username
    }
    
    var email: String {
        guard let email = signUpView.emailTextField.text else { return ""}
        return email
    }
    
    var password: String {
        guard let password = signUpView.passwordTextField.text else { return ""}
        return password
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = signUpView
        signUpView.interface = self
    }
    
    
}

//MARK: - SignUpViewInterface

extension SignUpController: SignUpViewInterface {
    func signUpButtonTapped(_ view: SignUpView) {
        signUpViewModel.signUp(username, email, password)
    }
    
    
}
