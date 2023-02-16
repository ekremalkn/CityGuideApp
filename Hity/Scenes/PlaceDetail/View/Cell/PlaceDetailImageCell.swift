//
//  PlaceDetailImageCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 15.02.2023.
//

import UIKit

final class PlaceDetailImageCell: UICollectionViewCell {
    
    //MARK: - Cell's Identifier
    
    static let identifier = "PlaceDetailImageCell"
    
    //MARK: - Creating UI Elements
    
    private let placeImageBackground: UIView = {
        let view = UIView()
        view.addShadow()
        return view
    }()
    
    private let placeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let ratingBlurView: UIVisualEffectView = {
        let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return visualView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private let ratingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor().hexStringToUIColor(hex: "#FAAC4B")
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
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
    
    func configure(_ photoData: DetailPhoto, _ placeData: DetailResults) {
        if let photoURL = photoData.photoReference {
            self.placeImage.downloadSetImage(type: .photoReference, url: photoURL)
        }

        if let rating = placeData.rating {
            self.ratingLabel.text = "\(rating)"
        }
        
    }
    
    
}

//MARK: - UI Elements AddSubview / Constraints

extension PlaceDetailImageCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(placeImageBackground)
        placeImageToBackgroundView()
        ratingStackViewToPlaceImage()
        ratingElementsToStackView()
        ratingBlurViewToStackView()
    }
    
    private func placeImageToBackgroundView() {
        placeImageBackground.addSubview(placeImage)
    }
    
    private func ratingStackViewToPlaceImage() {
        placeImage.addSubview(ratingStackView)
    }
    
    private func ratingElementsToStackView() {
        ratingStackView.addArrangedSubview(ratingImage)
        ratingStackView.addArrangedSubview(ratingLabel)
    }
    
    private func ratingBlurViewToStackView() {
        ratingStackView.insertSubview(ratingBlurView, at: 0)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        placeImageBackgroundConstraints()
        placeImageConstraints()
        ratingStackViewConstraints()
        ratingBlurViewConstraints()
    }
    
    private func placeImageBackgroundConstraints() {
        placeImageBackground.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func placeImageConstraints() {
        placeImage.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(placeImageBackground)
        }
    }
    
    private func ratingStackViewConstraints() {
        ratingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(placeImage.snp.bottom).offset(-10)
            make.trailing.equalTo(placeImage.snp.trailing).offset(-10)
        }
    }
    
    private func ratingBlurViewConstraints() {
        ratingBlurView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(ratingStackView)
        }
    }
    
    
    
}

