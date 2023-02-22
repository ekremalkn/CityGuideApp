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
    func signInButtonTapped(_ view: SignInView)
    func signUpButtonTapped(_ view: SignInView)
    func forgotPasswordButtonTapped(_ view: SignInView)
}
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
    
    private let passwordEyeButton = UIButton(type: .custom)
    
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
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .clear
        return button
    }()
    
    private let signInButton: UIButton = {
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
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    private let googleSignInBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(named: "googleLogo"), for: .normal)
        button.setTitle("Continue with Google", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        return button
    }()
    
    private let appleSignInButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    let facebookSignInButton = FBLoginButton()
    
    
    //MARK: - Properties
    
    weak var interface: SignInViewInterface?
    
    var passwordSecure = true
    
    //MARK: - Init Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        googleSignInBtn.addShadow()
        facebookSignInButton.addShadow()
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
        addTarget()
        configurePasswordTextFieldRightButton()
    }
    
    private func configurePasswordTextFieldRightButton() {
        passwordTextField.setRightVewButton(passwordEyeButton, "eye.slash")
    }
    
    //MARK: - AddAction
    
    private func addTarget() {
        googleSignInBtn.addTarget(self, action: #selector(signInGoogleButtonAction), for: .touchUpInside)
        appleSignInButton.addTarget(self, action: #selector(signInAppleButtonAction), for: .touchUpInside)
        passwordEyeButton.addTarget(self, action: #selector(passwordEyeButtonAction), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonAction), for: .touchUpInside)
        
    }
    
    @objc private func signInGoogleButtonAction(_ button: UIButton) {
        self.interface?.googleSignInButtonTapped(self)
    }
    
    @objc private func signInAppleButtonAction(_ button: UIButton) {
        self.interface?.appleSignInButtonTapped(self)
    }
    
    @objc private func passwordEyeButtonAction(_ button: UIButton) {
        passwordEyeButtonToggle()
    }
    
    @objc private func signInButtonAction(_ button: UIButton) {
        self.interface?.signInButtonTapped(self)
    }
    
    @objc private func signUpButtonAction(_ button: UIButton) {
        self.interface?.signUpButtonTapped(self)
    }
    
    @objc private func forgotPasswordButtonAction(_ button: UIButton) {
        self.interface?.forgotPasswordButtonTapped(self)
    }
    
    //MARK: - PasswordEyeButton Toggle
    
    private func passwordEyeButtonToggle() {
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
        providerStackView.addArrangedSubview(facebookSignInButton)
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

