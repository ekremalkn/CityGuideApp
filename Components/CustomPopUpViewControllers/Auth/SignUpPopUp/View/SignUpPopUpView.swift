//
//  SignUpPopUpView.swift
//  Hity
//
//  Created by Ekrem Alkan on 22.02.2023.
//

import UIKit

final class SignUpPopUpView: UIView {
    
    //MARK: - Creating UI Elements
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .green
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Your account has been created."
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Got it", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()


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
    
    //MARK: - If email verification true / false
    
    func accordingToEmailVerification(_ value: Bool) {
        if value {
            subTitleLabel.text = "Don't forget to verify your email. A verification link has been sent to your email account."
        }  else {
            subTitleLabel.textColor = .red
            subTitleLabel.text = "Failed to send verification email."
        }
    }

}



//MARK: - UI Elements AddSubview / Constraints

extension SignUpPopUpView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(contentView)
        elementsToContentView()
    }
    
    private func elementsToContentView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(okButton)
    }

    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        contentViewConstraints()
        imageViewConstraints()
        titleLabelConstraints()
        subTitleLabelConstraints()
        okButtonConstraints()
    }
    
    private func contentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
            make.height.equalTo(self.snp.height).multipliedBy(0.3333)
        }
    }
    
    private func imageViewConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.height.width.equalTo(contentView.snp.height).multipliedBy(0.30)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    private func titleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.2)
            make.width.equalTo(contentView.snp.width).offset(20)
            make.centerX.equalTo(imageView.snp.centerX)
        }
    }
    
    private func subTitleLabelConstraints() {
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.15)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
    }
    
    private func okButtonConstraints() {
        okButton.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height).multipliedBy(0.15)
            make.centerX.equalTo(imageView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.65)
        }
    }

}

