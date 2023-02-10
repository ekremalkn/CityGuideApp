//
//  SignInView.swift
//  Hity
//
//  Created by Ekrem Alkan on 10.02.2023.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit


protocol SignInViewInterface: AnyObject {
    func googleSignInButtonTapped(_ view: SignInView)
    func appleSignInButtonTapped(_ view: SignInView)
    func facebookSignInButttonTapped(_ view: SignInView)
}
final class SignInView: UIView {
    

    //MARK: - Creating UI Elements
    private let googleSignInButton = GIDSignInButton()
    private let appleSignInButton = ASAuthorizationAppleIDButton(type: .continue, style: .white)
    let facebookSignInButton = FBLoginButton()
    
    //MARK: - Properties
    
    weak var interface: SignInViewInterface?

    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ConfigureView
    
    private func configureView() {
        addSubView()
        setupConstraints()
        addTarget()
    }
    

    //MARK: - AddAction
    
    private func addTarget() {
        googleSignInButton.addTarget(self, action: #selector(signInGoogleButtonAction), for: .touchUpInside)
        appleSignInButton.addTarget(self, action: #selector(signInAppleButtonAction), for: .touchUpInside)
        facebookSignInButton.addTarget(self, action: #selector(facebookButtonAction), for: .touchUpInside)
    }

    @objc private func signInGoogleButtonAction(_ button: UIButton) {
        self.interface?.googleSignInButtonTapped(self)
    }
    
    @objc private func signInAppleButtonAction(_ button: UIButton) {
        self.interface?.appleSignInButtonTapped(self)
    }
    
    @objc private func facebookButtonAction(_ button: UIButton) {
        self.interface?.facebookSignInButttonTapped(self)
    }


}


//MARK: - UI Elements AddSubview  / Constraints

extension SignInView {
    
    //MARK: - AddSubview
    
    private func addSubView() {
        addSubview(googleSignInButton)
        addSubview(appleSignInButton)
        addSubview(facebookSignInButton)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        googleSignInButtonConstraints()
        appleSignInButtonConstraints()
        facebookSignInButtonConstraints()
    }
    
    private func googleSignInButtonConstraints() {
        googleSignInButton.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(110)
        }
    }
    
    private func appleSignInButtonConstraints() {
        appleSignInButton.snp.makeConstraints { make in
            make.top.equalTo(googleSignInButton.snp.bottom).offset(15)
            make.centerX.equalTo(googleSignInButton)
            
        }
    }
    
    private func facebookSignInButtonConstraints() {
        facebookSignInButton.snp.makeConstraints { make in
            make.top.equalTo(appleSignInButton.snp.bottom).offset(15)
            make.centerX.equalTo(appleSignInButton)
        }
    }
    
}

