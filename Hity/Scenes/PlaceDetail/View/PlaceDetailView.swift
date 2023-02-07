//
//  PlaceDetailView.swift
//  Hity
//
//  Created by Ekrem Alkan on 5.02.2023.
//

import UIKit

final class PlaceDetailView: UIView {

    //MARK: - Creating UI Elements
    
    private let placeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "heart")
        return imageView
    }()

    private let placeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Elmalı Konak Dondurma"
        return label
    }()
    
    private let ratingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.orange, for: .normal)
        return button
    }()
    
    private let placeAddressView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let placeAdressImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location")
        return imageView
    }()
    
    private let placeAdress: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Metin Kasapoğlu Caddesi No: 44 Apt: Armada"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemGray
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let addressInfoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Adres Bilgileri", for: .normal)
        return button
    }()
    
    private let openClosedInfoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Çalışma Saatleri", for: .normal)
        return button
    }()
    
    private let reviewsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Yorumlar", for: .normal)
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
        backgroundColor = .white
        addSubview()
        setupConstraints()
    }
    
    func configure(data: DetailResults) {
        if let photo =   data.photos?[0].photoReference {
            self.placeImage.downloadSetImage(url: photo)

        }
        self.placeName.text = data.name
        self.ratingButton.setTitle("\(data.rating)", for: .normal)
        self.placeAdress.text = data.formattedAddress
    }
    
}

//MARK: - UI Elements AddSubview / Constraints

extension PlaceDetailView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(placeImage)
        saveButtonToImageView()
        addSubview(placeName)
        addSubview(ratingButton)
        addSubview(placeAddressView)
        addressAndImageToView()
        addSubview(buttonStackView)
        buttonsToStackView()
        
    }
    
    private func saveButtonToImageView() {
        placeImage.addSubview(saveButton)
    }
    
    private func addressAndImageToView() {
        placeAddressView.addSubview(placeAdressImage)
        placeAddressView.addSubview(placeAdress)
    }
    
    private func buttonsToStackView() {
        buttonStackView.addArrangedSubview(addressInfoButton)
        buttonStackView.addArrangedSubview(openClosedInfoButton)
        buttonStackView.addArrangedSubview(reviewsButton)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        placeImageConstraints()
        saveButtonConstraints()
        placeNameConstraints()
        ratingButtonConstraints()
        placeAddressViewConstraints()
        placeAddressImageConstraints()
        placeAddressConstraints()
        buttonStackViewConstraints()
    }
    
    
    private func placeImageConstraints() {
        placeImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
    }
    
    private func saveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(placeImage.snp.bottom).offset(20)
            make.trailing.equalTo(placeImage.snp.trailing).offset(-20)
        }
    }
    
    private func placeNameConstraints() {
        placeName.snp.makeConstraints { make in
            make.top.equalTo(placeImage.snp.bottom).offset(20)
            make.leading.equalTo(placeImage.snp.leading)
            make.height.equalTo(placeName.snp.height)
        }
    }
    
    private func ratingButtonConstraints() {
        ratingButton.snp.makeConstraints { make in
            make.height.equalTo(placeName.snp.height)
            make.centerY.equalTo(placeName.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func placeAddressViewConstraints() {
        placeAddressView.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(10)
            make.leading.equalTo(placeName.snp.leading)
            make.trailing.equalTo(placeAdress.snp.trailing)
            make.height.equalTo(placeAdress.snp.height)
        }
    }
    
    private func placeAddressImageConstraints() {
        placeAdressImage.snp.makeConstraints { make in
            make.centerY.equalTo(placeAddressView.snp.centerY)
            make.leading.equalTo(placeAddressView.snp.leading).offset(5)
            make.height.width.equalTo(placeAdress.snp.height)
        }
    }
    
    private func placeAddressConstraints() {
        placeAdress.snp.makeConstraints { make in
            make.centerY.equalTo(placeAddressView.snp.centerY)
            make.leading.equalTo(placeAdressImage.snp.trailing).offset(5)
            make.trailing.equalTo(placeAddressView.snp.trailing)
        }
    }
    
    private func buttonStackViewConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(placeAddressView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(50)
        }
    }

}

