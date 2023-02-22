//
//  ResetPasswordView.swift
//  Hity
//
//  Created by Ekrem Alkan on 20.02.2023.
//

import UIKit
import RxSwift

final class ResetPasswordView: UIView {
    
    //MARK: - Creating UI Elements
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot your password?"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your email."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Email Address"
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.isUserInteractionEnabled = false
        textField.setLeftPaddingPoints(15)
        return textField
    }()
    
    let submitCallbackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let submitButton: CircleButton = {
        let button = CircleButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    //MARK: - Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        seperatorView.layer.cornerRadius = seperatorView.frame.height / 2
        seperatorView.layer.masksToBounds = true
    }

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
    }
    
    
    
}


//MARK: - UI Elements AddSubview / Setup Constraints


extension ResetPasswordView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(emptyView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(seperatorView)
        addSubview(emailTextField)
        addSubview(submitCallbackLabel)
        addSubview(submitButton)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        titleLabelConstraints()
        subTitleLabelConstraints()
        seperatorViewConstraints()
        emailTextFieldConstraints()
        submitCallbackLabelConstraints()
        submitButtonConstraints()
    }
    
    private func emptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.1666667)
        }
    }
    
    private func titleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide).offset(15)
        }
    }
    
    private func subTitleLabelConstraints() {
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }
    }
    
    private func seperatorViewConstraints() {
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(25)
            make.leading.equalTo(safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(1.5)
        }
    }
    
    private func emailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(25)
            make.leading.trailing.equalTo(seperatorView)
            make.height.equalTo(self).multipliedBy(0.08333334)
        }
    }
    
    private func submitCallbackLabelConstraints() {
        submitCallbackLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(45)
        }
    }
    
    private func submitButtonConstraints() {
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(submitCallbackLabel.snp.bottom).offset(20)
            make.height.equalTo(emailTextField.snp.height).multipliedBy(0.75)
            make.width.equalTo(emailTextField.snp.height).multipliedBy(2)
            make.leading.equalTo(titleLabel)
        }
    }
    
}
