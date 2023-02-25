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
    
    let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.addShadow()
        return view
    }()
    
    let topGrabber: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
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
    
    let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.contentMode = .scaleToFill
        return activityIndicator
    }()
    
    //MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()    
    
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
        backgroundColor = .clear
        addSubview()
        setupConstraints()
    }
    
    
    
}


//MARK: - UI Elements AddSubview / Setup Constraints


extension ResetPasswordView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(emptyView)
        addSubview(contentView)
        elementsToContentView()
    }
    
    private func elementsToContentView() {
        contentView.addSubview(topGrabber)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(seperatorView)
        contentView.addSubview(emailTextField)
        contentView.addSubview(submitCallbackLabel)
        contentView.addSubview(submitButton)
        contentView.addSubview(activityIndicator)
    }
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        contentViewConstraints()
        topGrabberConstraints()
        titleLabelConstraints()
        subTitleLabelConstraints()
        seperatorViewConstraints()
        emailTextFieldConstraints()
        submitCallbackLabelConstraints()
        submitButtonConstraints()
        activityIndicatorConstraints()
    }
    
    
    
    private func emptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.snp.centerY)
        }
    }
    
    private func contentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
    
    private func topGrabberConstraints() {
        topGrabber.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.top.equalTo(contentView.snp.top).offset(3)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.15)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    private func titleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topGrabber.snp.bottom)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.15)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
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
            make.height.equalTo(contentView.snp.height).multipliedBy(0.1666667)
        }
    }
    
    private func submitCallbackLabelConstraints() {
        submitCallbackLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.1)
        }
    }
    
    private func submitButtonConstraints() {
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(submitCallbackLabel.snp.bottom).offset(20)
            make.leading.equalTo(emailTextField.snp.leading)
            make.height.equalTo(emailTextField.snp.height).multipliedBy(0.75)
            make.width.equalTo(emailTextField.snp.height).multipliedBy(2)
        }
    }
    
    private func activityIndicatorConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(submitButton.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(submitButton.snp.height)
        }
    }
}
