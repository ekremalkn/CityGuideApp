//
//  FavoriteCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 8.02.2023.
//

import UIKit

final class FavoriteCell: UICollectionViewCell {
    
    //MARK: - Cell's Identifier
    
    static let identifier = "FavoriteCell"

    
    //MARK: - Creating UI Elements
    
    private let placeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private let favButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let ratingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "4.7"
        return label
    }()
    
    private let placeName: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let addressImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        return imageView
    }()
    
    private let address: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Cell
    
    private func configureCell() {
        addSubview()
        setupConstraints()
    }


}

//MARK: - UI Elements AddSubview / Constraints

extension FavoriteCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(placeImage)
        addFavButtonToImage()
        ratingElementsToStackView()
        addSubview(placeName)
        addSubview(addressStackView)
        addressElementsToStackView()

    }
    
    private func addFavButtonToImage() {
        placeImage.addSubview(favButton)
        placeImage.addSubview(ratingStackView)
    }
    
    private func ratingElementsToStackView() {
        ratingStackView.addArrangedSubview(ratingImage)
        ratingStackView.addArrangedSubview(ratingLabel)
    }
    
    private func addressElementsToStackView() {
        addressStackView.addArrangedSubview(addressImage)
        addressStackView.addArrangedSubview(address)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        placeImageConstraints()
        favButtonConstraints()
        ratingStackViewConstraints()
        ratingImageConstraints()
        ratingLabelConstraints()
        placeNameConstraints()
        addressStackViewConstraints()
        addressImageConstraints()
        addressConstraints()
    }
    
    private func placeImageConstraints() {
        placeImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(safeAreaLayoutGuide).multipliedBy(0.66)
        }
    }
    
    private func favButtonConstraints() {
        favButton.snp.makeConstraints { make in
            make.trailing.equalTo(placeImage).offset(10)
            make.top.equalTo(placeImage).offset(10)
            make.height.width.equalTo(placeImage.snp.height).multipliedBy(0.25)
        }
    }
    
    private func ratingStackViewConstraints() {
        ratingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(placeImage).offset(-10)
            make.trailing.equalTo(placeImage).offset(-10)
            make.height.equalTo(placeImage.snp.height).multipliedBy(0.25)
        }
    }
    
    private func ratingImageConstraints() {
        ratingImage.snp.makeConstraints { make in
            make.leading.equalTo(ratingStackView)
            make.top.bottom.equalTo(ratingStackView)
            make.width.equalTo(ratingImage.snp.height)
        }
    }
    
    private func ratingLabelConstraints() {
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(ratingImage.snp.trailing).offset(5)
            make.width.equalTo(ratingLabel.snp.height)
        }
    }
    
    private func placeNameConstraints() {
        placeName.snp.makeConstraints { make in
            make.top.equalTo(placeImage.snp.bottom).offset(10)
            make.leading.equalTo(placeImage)
            make.trailing.equalTo(placeImage)
            make.height.equalTo(placeName.snp.height)
        }
    }
    
    private func addressStackViewConstraints() {
        addressStackView.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(5)
            make.leading.trailing.equalTo(placeName)
            make.height.equalTo(addressImage.snp.height)
        }
    }
    
    private func addressImageConstraints() {
        addressImage.snp.makeConstraints { make in
            make.leading.equalTo(addressStackView)
            make.top.bottom.equalTo(addressStackView)
        }
    }
    
    private func addressConstraints() {
        address.snp.makeConstraints { make in
            make.leading.equalTo(addressImage.snp.trailing).offset(5)
            make.trailing.equalTo(addressStackView)
        }
    }

}

