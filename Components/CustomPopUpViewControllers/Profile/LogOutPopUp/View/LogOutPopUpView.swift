//
//  LogOutPopUpView.swift
//  Hity
//
//  Created by Ekrem Alkan on 22.02.2023.
//

import UIKit

final class LogOutPopUpView: UIView {
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
  
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Exit"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Are you sure you want to exit Hity?"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 25
        return stackView
    }()
    
    let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Yes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("No", for: .normal)
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



}

//MARK: - UI Elements AddSubview / Constraints

extension LogOutPopUpView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(contentView)
        elementsToContentView()
        buttonsToStackView()
    }
    
    private func elementsToContentView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(buttonStackView)
    }
    
    private func buttonsToStackView() {
        buttonStackView.addArrangedSubview(yesButton)
        buttonStackView.addArrangedSubview(noButton)
    }

    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        contentViewConstraints()
        titleLabelConstraints()
        subTitleLabelConstraints()
        buttonStackViewConstraints()
    }
    
    private func contentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
            make.height.equalTo(self.snp.height).multipliedBy(0.16667)
        }
    }
    
    private func titleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(15)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.2)
            make.width.equalTo(contentView.snp.width).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    private func subTitleLabelConstraints() {
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.2)
            make.width.equalTo(titleLabel.snp.width)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
    }
    
    
    private func buttonStackViewConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.trailing.equalTo(contentView.snp.leading).offset(-15)
        }
    }
    

}

