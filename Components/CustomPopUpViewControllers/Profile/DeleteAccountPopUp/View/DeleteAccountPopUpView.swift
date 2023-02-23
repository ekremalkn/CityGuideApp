//
//  DeleteAccountPopUpView.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import UIKit

final class DeleteAccountPopUpView: UIView {

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
        label.text = "Are you sure you want to delete your account?"
        label.textColor = .red
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
   
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm you want to delete this collection by typing your password."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let seperatorView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
        
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Enter your email"
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
    
    let deleteButton: CircleButton = {
        let button = CircleButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.contentMode = .scaleToFill
        return activityIndicator
    }()
    
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

extension DeleteAccountPopUpView {
    
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
        contentView.addSubview(emailTextField)
        contentView.addSubview(seperatorView)
        contentView.addSubview(viewModelCallbackLabel)
        contentView.addSubview(deleteButton)
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
        viewModelCallbackLabelConstraints()
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
            make.bottom.trailing.leading.equalTo(self)
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
            make.height.equalTo(contentView.snp.height).multipliedBy(0.2)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
        }
    }
    
    private func subTitleLabelConstraints() {
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(40)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
    
    private func seperatorViewConstraints() {
        seperatorView.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
    
    private func emailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.1666667)
        }
    }
    
    private func viewModelCallbackLabelConstraints() {
        viewModelCallbackLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.15)
            make.leading.trailing.equalTo(emailTextField)
        }
    }
    
    private func submitButtonConstraints() {
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(viewModelCallbackLabel.snp.bottom).offset(25)
            make.leading.equalTo(emailTextField.snp.leading)
            make.height.equalTo(emailTextField.snp.height).multipliedBy(0.75)
            make.width.equalTo(emailTextField.snp.height).multipliedBy(2)
        }
    }
    
    private func activityIndicatorConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(deleteButton.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.width.equalTo(deleteButton.snp.height)
        }
    }


}

