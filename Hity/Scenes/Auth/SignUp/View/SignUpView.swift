//
//  SignUpView.swift
//  Hity
//
//  Created by Ekrem Alkan on 11.02.2023.
//

import UIKit
import RxSwift

protocol SignUpViewInterface: AnyObject {
    func signUpButtonTapped(_ view: SignUpView)
}

final class SignUpView: UIView {
    
    //MARK: - Creating UI Elements
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Sign up now"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "Please fill the details and create account"
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
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Username"
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(15)
        
        return textField
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
    
    private let passwordRequirementView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let passwordRequirementLabel: UILabel = {
        let label = UILabel()
        label.text = "Password must be 8 chracter"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let passwordRequirementImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: - Properties
    
    weak var interface: SignUpViewInterface?
    private let disposeBag = DisposeBag()
    var passwordText = PublishSubject<String>()
    
    var passwordSecure = true
    
    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure View
    
    private func configureView() {
        backgroundColor = .white
        addSubview()
        setupConstraints()
        addTarget()
        configurePasswordTextFieldRightButton()
    }
    
    private func configurePasswordTextFieldRightButton() {
        passwordTextField.setRightVewButton(passwordEyeButton, "eye.slash")
    }
    
    //MARK: - Addtarget
    
    private func addTarget() {
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        passwordEyeButton.addTarget(self, action: #selector(passwordEyeButtonAction), for: .touchUpInside)
    }
    
    @objc private func signUpButtonAction(_ button: UIButton) {
        reactivePasswordTextField()
        if let passwordChracter = passwordTextField.text?.count {
            if passwordChracter >= 8 {
                self.interface?.signUpButtonTapped(self)
            }
            else {
                print("karakter sayısı 8 den az ")
            }
        }
    }
    
    @objc private func passwordEyeButtonAction(_ button: UIButton) {
        passwordEyeButtonToggle()
    }
    
    //MARK: - Configure Password TextField
    
    private func reactivePasswordTextField() {
        passwordTextField.rx.text.bind { [weak self] text in
            if let text = text {
                if text.count >= 8 {
                    self?.passwordRequirementImageToogle(true)
                } else {
                    self?.passwordRequirementImageToogle(false)
                }
            }
        }.disposed(by: disposeBag)
        
    }
    
    private func passwordRequirementImageToogle(_ requirement: Bool) {
        if requirement {
            passwordRequirementImage.image = UIImage(systemName: "checkmark")
            passwordRequirementImage.tintColor = .green
            passwordRequirementImage.isHidden = false
        } else {
            passwordRequirementImage.image = UIImage(systemName: "multiply")
            passwordRequirementImage.tintColor = .red
            passwordRequirementImage.isHidden = false
        }
        
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

//MARK: - UI Elements AddSubview / Constraints

extension SignUpView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(emptyView)
        addSubview(titleView)
        titlesToView()
        addSubview(textFieldStackView)
        textFieldsToStackView()
        passwordRequirementsToView()
    }
    
    private func titlesToView() {
        titleView.addSubview(title)
        titleView.addSubview(subTitle)
    }
    
    private func textFieldsToStackView() {
        textFieldStackView.addArrangedSubview(userNameTextField)
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        textFieldStackView.addArrangedSubview(passwordRequirementView)
        textFieldStackView.addArrangedSubview(signUpButton)
    }
    
    private func passwordRequirementsToView() {
        passwordRequirementView.addSubview(passwordRequirementLabel)
        passwordRequirementView.addSubview(passwordRequirementImage)
        
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        titleViewConstraints()
        titleConstraints()
        subTitleConstraints()
        textFieldStackViewConstraints()
        passwordRequirementLabelConstraints()
        passwordRequirementImageConstraints()
    }
    
    private func emptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.083333335)
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
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func passwordRequirementLabelConstraints() {
        passwordRequirementLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordRequirementView.snp.top)
        }
    }
    
    private func passwordRequirementImageConstraints() {
        passwordRequirementImage.snp.makeConstraints { make in
            make.leading.equalTo(passwordRequirementLabel.snp.trailing).offset(10)
            make.centerY.equalTo(passwordRequirementLabel.snp.centerY)
        }
    }
    
    
}

