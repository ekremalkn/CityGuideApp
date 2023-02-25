//
//  PlaceDetailImageCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 15.02.2023.
//

import UIKit


protocol PlaceDetailCellProtocol {
    var placeDetailCellImage: String { get }
}

protocol PlaceDetailCellRatingsProtocol {
        var placeDetailCellRatingTotal: String { get }
        var placeDetailCellRating: String { get }
}

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
    
    
    let userRatingTotalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    let userRatingTotalImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    let userRatingTotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let ratingBlurView: UIVisualEffectView = {
        let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return visualView
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
    
    func configurePhotos(_ data: PlaceDetailCellProtocol) {
        self.placeImage.downloadSetImage(type: .photoReference, url: data.placeDetailCellImage)
    }
    
    func configureRatings(_ data: PlaceDetailCellRatingsProtocol) {
        self.userRatingTotalLabel.text = "\(data.placeDetailCellRatingTotal) total ratings"
        self.ratingLabel.text = data.placeDetailCellRating
    }
    
    
}

//MARK: - UI Elements AddSubview / Constraints

extension PlaceDetailImageCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(placeImageBackground)
        placeImageToBackgroundView()
        ratingViewToPlaceImage()
        ratingElementsToStackView()
        ratingBlurViewToStackView()
    }
    
    private func placeImageToBackgroundView() {
        placeImageBackground.addSubview(placeImage)
    }
    
    private func ratingViewToPlaceImage() {
        placeImage.addSubview(ratingView)
        
        placeImage.addSubview(userRatingTotalStackView)
    }
    
    private func ratingElementsToStackView() {
        ratingView.addSubview(ratingImage)
        ratingView.addSubview(ratingLabel)
        
        userRatingTotalStackView.addArrangedSubview(userRatingTotalImage)
        userRatingTotalStackView.addArrangedSubview(userRatingTotalLabel)
    }
    
    private func ratingBlurViewToStackView() {
        ratingView.insertSubview(ratingBlurView, at: 0)
        
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        placeImageBackgroundConstraints()
        placeImageConstraints()
        userRatingTotalStackViewConstraints()
        ratingViewConstraints()
        ratingBlurViewConstraints()
        ratingImageConstraints()
        ratingLabelConstraints()
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
    
    private func userRatingTotalStackViewConstraints() {
        userRatingTotalStackView.snp.makeConstraints { make in
            make.bottom.equalTo(placeImage.snp.bottom).offset(-10)
            make.leading.equalTo(placeImage.snp.leading).offset(10)
        }
    }

    private func ratingViewConstraints() {
        ratingView.snp.makeConstraints { make in
            make.bottom.equalTo(placeImage.snp.bottom).offset(-10)
            make.trailing.equalTo(placeImage.snp.trailing).offset(-10)
            make.height.equalTo(placeImage.snp.height).multipliedBy(0.10)
            make.width.equalTo(placeImage.snp.width).multipliedBy(0.15)
        }
    }
    
    private func ratingBlurViewConstraints() {
        ratingBlurView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(ratingView)
        }
    }
    
    private func ratingImageConstraints() {
        ratingImage.snp.makeConstraints { make in
            make.leading.equalTo(ratingView.snp.leading).offset(5)
            make.centerY.equalTo(ratingView.snp.centerY)
            make.height.width.equalTo(ratingView.snp.height).multipliedBy(0.5)
        }
    }
    
    
    private func ratingLabelConstraints() {
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalTo(ratingView.snp.trailing).offset(-5)
            make.centerY.equalTo(ratingImage.snp.centerY)
        }
    }
    
    
    
}

