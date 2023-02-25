//
//  ProfileView.swift
//  Hity
//
//  Created by Ekrem Alkan on 19.02.2023.
//

import UIKit
import RxSwift

final class ProfileView: UIView {
    
    //MARK: - Creating UI Elements
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .systemGray4
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Ekrem Alkan"
        return label
    }()
    
    var profileImageActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.contentMode = .scaleToFill
        activityIndicator.color = .blue
        return activityIndicator
    }()
    
    let editButton: CircleButton = {
        let button = CircleButton(type: .custom)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    var pickerControllerActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.contentMode = .scaleToFill
        activityIndicator.color = .blue
        return activityIndicator
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemGray6
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1.5
        return stackView
    }()
    
    let changeUserNameButton: UIButton = {
        let button = ProfileViewButton(type: .system)
        button.setTitle("Change Username", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "pencil.and.outline"), for: .normal)
        button.rightImage.image = UIImage(systemName: "chevron.right")
        button.backgroundColor = .white
        button.tintColor = .black
        return button
    }()
    
    let changeEmailButton: UIButton = {
        let button = ProfileViewButton(type: .system)
        button.setTitle("Change Email", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "envelope.open"), for: .normal)
        button.rightImage.image = UIImage(systemName: "chevron.right")
        button.backgroundColor = .white
        button.tintColor = .black
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button = ProfileViewButton(type: .system)
        button.setTitle("Delete Account", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .red
        return button
    }()
    
    let changePasswordButton: ProfileViewButton = {
        let button = ProfileViewButton(type: .system)
        button.setTitle("Change Password", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "lock.fill"), for: .normal)
        button.rightImage.image = UIImage(systemName: "chevron.right")
        button.backgroundColor = .white
        button.tintColor = .black
        return button
    }()
    
    let logOutButton: ProfileViewButton = {
        let button = ProfileViewButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.red, for: .normal)
        button.setImage(UIImage(systemName: "xmark.rectangle"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .red
        return button
    }()
    
    //MARK: - DisposeBag
    
    let disposeBag = DisposeBag()
    
    //MARK: - Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.masksToBounds = true
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

//MARK: - UI Elements AddSubview / Constraints

extension ProfileView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(emptyView)
        addSubview(profileImageView)
        addActivityIndicatorToProfileImage()
        addSubview(editButton)
        addSubview(userNameLabel)
        addSubview(seperatorView)
        addSubview(buttonStackView)
        buttonsToStackView()
    }
    
    private func addActivityIndicatorToProfileImage() {
        profileImageView.addSubview(profileImageActivityIndicator)
        emptyView.addSubview(pickerControllerActivityIndicator)
        
    }
    
    private func buttonsToStackView() {
        buttonStackView.addArrangedSubview(changeUserNameButton)
        buttonStackView.addArrangedSubview(changeEmailButton)
        buttonStackView.addArrangedSubview(changePasswordButton)
        buttonStackView.addArrangedSubview(deleteAccountButton)
        buttonStackView.addArrangedSubview(logOutButton)
    }
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        profileImageConstraints()
        profileImageActivityIndicatorConstraints()
        editButtonConstraints()
        userNameLabelConstraints()
        pickerControllerActivityIndicatorConstraints()
        seperatorViewConstraints()
        buttonStackViewConstraints()
    }
    
    private func emptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.08333334)
        }
    }
    
    private func profileImageConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.bottom)
            make.centerX.equalTo(safeAreaLayoutGuide.snp.centerX)
            make.height.width.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.32)
        }
    }
    
    
    private func profileImageActivityIndicatorConstraints() {
        profileImageActivityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(profileImageView)
            make.height.width.equalTo(emptyView.snp.height)
        }
    }
    
    private func editButtonConstraints() {
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(profileImageView.snp.height).multipliedBy(0.2)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(20)
            make.bottom.equalTo(profileImageView.snp.bottom).offset(20)
            
        }
    }
    
    private func userNameLabelConstraints() {
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.041666667)
        }
    }
    
    private func pickerControllerActivityIndicatorConstraints() {
        pickerControllerActivityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(emptyView)
            make.height.width.equalTo(emptyView.snp.height)
        }
    }
    
    private func seperatorViewConstraints() {
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.height.equalTo(1.5)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    private func buttonStackViewConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
}

