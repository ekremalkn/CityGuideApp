//
//  SignInView.swift
//  Hity
//
//  Created by Ekrem Alkan on 10.02.2023.
//

import UIKit
import RxSwift
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit


final class SignInView: UIView {
    
    
    //MARK: - Creating UI Elements
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.contentMode = .scaleToFill
        return activityIndicator
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Sign in now"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "Please sign in to continue our app"
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Email Address"
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(15)
        return textField
    }()
    
    let passwordEyeButton = UIButton(type: .custom)
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Password"
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(15)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let forgotPasswordView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let signInErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 4
        return label
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .clear
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let providerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()

    let googleSignInBtn = ProviderSignInButton(UIImage(named: "google1x")!, "Continue with Google", .white, .black)
    
    let facebookSignInBtn = ProviderSignInButton(UIImage(named: "facebook1x")!, "Continue with Facebook", UIColor().hexStringToUIColor(hex: "3B5997"), .white)
    
    let appleSignInButton = ProviderSignInButton(UIImage(named: "apple1x")!, "Continue with Apple", .black, .white)
    
    //MARK: - Properties
    
    let disposeBag = DisposeBag()
    var passwordSecure = true
    
    //MARK: - Init Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        appleSignInButton.addShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ConfigureView
    
    private func configureView() {
        backgroundColor = .white
        addSubView()
        setupConstraints()
        configurePasswordTextFieldRightButton()
    }
    
    private func configurePasswordTextFieldRightButton() {
        passwordTextField.setRightVewButton(passwordEyeButton, "eye.slash")
    }
    
    
    //MARK: - PasswordEyeButton Toggle
    
    func passwordEyeButtonToggle() {
        if passwordSecure {
            passwordTextField.isSecureTextEntry = false
            passwordTextField.setRightVewButton(passwordEyeButton, "eye")
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.setRightVewButton(passwordEyeButton, "eye.slash")
        }
        passwordSecure = !passwordSecure
    }
    
}


//MARK: - UI Elements AddSubview  / Constraints

extension SignInView {
    
    //MARK: - AddSubview
    
    private func addSubView() {
        addSubview(emptyView)
        addSubview(titleView)
        titlesToView()
        addSubview(textFieldStackView)
        textFieldsToStackView()
        forgotPasswordButtonToView()
        addSubview(orLabel)
        addSubview(providerStackView)
        providerButtonsToStackView()
        addSubview(signUpStackView)
        signUpElementsToStackView()
    }
    
    private func titlesToView() {
        titleView.addSubview(title)
        titleView.addSubview(subTitle)
    }
    
    
    private func textFieldsToStackView() {
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        textFieldStackView.addArrangedSubview(forgotPasswordView)
        textFieldStackView.addArrangedSubview(signInButton)
    }
    
    private func forgotPasswordButtonToView() {
        forgotPasswordView.addSubview(signInErrorLabel)
        forgotPasswordView.addSubview(forgotPasswordButton)
        forgotPasswordView.addSubview(activityIndicator)
    }
    
    private func providerButtonsToStackView() {
        providerStackView.addArrangedSubview(googleSignInBtn)
        providerStackView.addArrangedSubview(facebookSignInBtn)
        providerStackView.addArrangedSubview(appleSignInButton)
    }
    
    private func signUpElementsToStackView() {
        signUpStackView.addArrangedSubview(signUpLabel)
        signUpStackView.addArrangedSubview(signUpButton)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        titleViewConstraints()
        titleConstraints()
        subTitleConstraints()
        textFieldStackViewConstraints()
        activityIndicatorConstraints()
        forgotPasswordButtonConstraints()
        signInErrorLabelConstraints()
        orLabelConstraints()
        providerStackViewConstraints()
        signUpStackViewConstraints()
    }
    
    private func emptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.083333335)
        }
    }
    
    private func activityIndicatorConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(emptyView)
            make.centerX.centerY.equalTo(forgotPasswordView)
        }
    }
    
    private func titleViewConstraints() {
        titleView.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.bottom)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.25)
        }
    }
    
    private func titleConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.top)
            make.centerX.equalTo(titleView.snp.centerX)
        }
    }
    
    private func subTitleConstraints() {
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.centerX.equalTo(title.snp.centerX)
        }
    }
    
    private func textFieldStackViewConstraints() {
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(30)
            make.leading.equalTo(safeAreaLayoutGuide).offset(30)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.35333334)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func forgotPasswordButtonConstraints() {
        forgotPasswordButton.snp.makeConstraints { make in
            make.trailing.equalTo(forgotPasswordView.snp.trailing)
            make.top.equalTo(forgotPasswordView.snp.top)
            make.width.equalTo(forgotPasswordView.snp.width).multipliedBy(0.35)
        }
    }
    
    private func signInErrorLabelConstraints() {
        signInErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(forgotPasswordView.snp.leading)
            make.top.equalTo(forgotPasswordView.snp.top)
            make.trailing.equalTo(forgotPasswordButton.snp.leading).offset(-5)
        }
    }
    
    
    private func orLabelConstraints() {
        orLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(15)
            make.centerX.equalTo(textFieldStackView.snp.centerX)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.04166666675)
        }
    }
    
    private func providerStackViewConstraints() {
        providerStackView.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(15)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.20)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.66)
            
        }
    }
    
    private func signUpStackViewConstraints() {
        signUpStackView.snp.makeConstraints { make in
            make.top.equalTo(providerStackView.snp.bottom).offset(15)
            make.centerX.equalTo(providerStackView.snp.centerX)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.04166666675)
        }
    }
    
    
    
}

