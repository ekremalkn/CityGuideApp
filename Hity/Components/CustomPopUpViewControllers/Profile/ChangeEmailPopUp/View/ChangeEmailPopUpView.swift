//
//  ChangeEmailPopUpView.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import UIKit
import RxSwift

final class ChangeEmailPopUpView: UIView {
    
    
    //MARK: - Creating UI Elements
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change your email."
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.frame.size.height = 1.5
        return view
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    let currentEmailTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Current Email"
        textField.textColor = .systemGray
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.isUserInteractionEnabled = false
        textField.setLeftPaddingPoints(15)
        return textField
    }()
    
    let newEmailTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.backgroundColor = .systemGray6
        textField.placeholder = "New Email"
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(15)
        return textField
    }()
    
    let confirmNewEmailTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Confirm New Email"
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(15)
        return textField
    }()
    
    let viewModelCallbackLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
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
    
    
    let logOutButton: CircleButton = {
        let button = CircleButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "xmark.rectangle"), for: .normal)
        button.backgroundColor = .red
        button.isHidden = true
        return button
    }()
    
    //MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()

    //MARK: - Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topGrabber.layer.cornerRadius = topGrabber.frame.height / 2
        topGrabber.layer.masksToBounds = true
    }

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
        backgroundColor = .clear
        addSubview()
        setupConstraints()
    }
    
    
}

//MARK: - UI Elements AddSubview / Constraints

extension ChangeEmailPopUpView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(emptyView)
        addSubview(contentView)
        elementsToContentView()
        textFieldsToStackView()
    }
    
    private func elementsToContentView() {
        contentView.addSubview(topGrabber)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textFieldStackView)
        contentView.addSubview(viewModelCallbackLabel)
        contentView.addSubview(submitButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(logOutButton)
    }
    
    private func textFieldsToStackView() {
        textFieldStackView.addArrangedSubview(currentEmailTextField)
        textFieldStackView.addArrangedSubview(newEmailTextField)
        textFieldStackView.addArrangedSubview(confirmNewEmailTextField)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        contentViewConstraints()
        topGrabberConstraints()
        titleLabelConstraints()
        textFieldStackViewConstraints()
        viewModelCallbackLabelConstraints()
        submitButtonConstraints()
        activityIndicatorConstraints()
        logOutButtonConstraints()
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
            make.bottom.equalTo(self.snp.bottom)
            make.leading.trailing.equalTo(self)
        }
    }
    
    private func topGrabberConstraints() {
        topGrabber.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.top.equalTo(contentView.snp.top).offset(7)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.10)
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
    
    private func textFieldStackViewConstraints() {
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.5)
        }
    }
    
    private func viewModelCallbackLabelConstraints() {
        viewModelCallbackLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(textFieldStackView)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.1)
        }
    }
    
    private func submitButtonConstraints() {
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(viewModelCallbackLabel.snp.bottom)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.15)
            make.width.equalTo(submitButton.snp.height).multipliedBy(3)
        }
    }
    
    private func activityIndicatorConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(currentEmailTextField.snp.centerY)
            make.centerX.equalTo(currentEmailTextField.snp.centerX)
            make.height.width.equalTo(submitButton.snp.height)
        }
    }
    
    private func logOutButtonConstraints() {
        logOutButton.snp.makeConstraints { make in
            make.top.equalTo(viewModelCallbackLabel.snp.bottom)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.15)
            make.width.equalTo(submitButton.snp.height).multipliedBy(3)
        }
    }
    
    
}

