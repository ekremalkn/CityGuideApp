//
//  FavoriteCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 8.02.2023.
//

import UIKit
import RxSwift
import CoreLocation

protocol FavoriteCellProtocol {
    var favoriteCellPlaceImage: String { get }
    var favoriteCellRating: String { get }
    var favoriteCellPlaceName: String { get }
    var favoriteCellAddress: String { get }
    var favoriteCellLocation: CLLocationCoordinate2D { get }
}

final class FavoriteCell: UICollectionViewCell {
    
    //MARK: - Cell's Identifier
    
    static let identifier = "FavoriteCell"
    
    
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
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let favButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private let ratingBlurView: UIVisualEffectView = {
        let visiualView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return visiualView
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
    
    let placeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    let showLocationButton: CircleButton = {
        let button = CircleButton(type: .system)
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.setTitle("Show on Apple Maps", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tintColor = .darkGray
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .systemGray6
        return button
    }()

    
    
    
    private (set) var disposeBag = DisposeBag()
    //observable variables
    
    var favButtonTap: Observable<Void> {
        return self.favButton.rx.tap.asObservable()
    }
    
    var locationButtonTap: Observable<Void> {
        return self.showLocationButton.rx.tap.asObservable()
    }
    
    var location = CLLocationCoordinate2D()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        
    }
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
        toggleFavButton()
    }
    
    func configure(_ data: FavoriteCellProtocol) {
        placeImage.downloadSetImage(type: .photoReference, url: data.favoriteCellPlaceImage)
        ratingLabel.text = data.favoriteCellRating
        placeName.text = data.favoriteCellPlaceName
        self.location = data.favoriteCellLocation
    }
    
    //MARK: - Toogle fav button
    
    func toggleFavButton() {
        let image = UIImage(systemName: "heart")
        let imageFilled = UIImage(systemName: "heart.fill")
        favButton.setImage(image, for: .normal)
        favButton.setImage(imageFilled, for: .selected)
    }
    
    
}

//MARK: - UI Elements AddSubview / Constraints

extension FavoriteCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(placeImageBackground)
        placeImageToBackgroundView()
        addFavButtonToImage()
        addRatingStackViewToImage()
        ratingElementsToStackView()
        ratingBlurViewToStackView()
        addSubview(placeName)
        addSubview(showLocationButton)
    }
    
    private func placeImageToBackgroundView() {
        placeImageBackground.addSubview(placeImage)
    }
    
    private func addFavButtonToImage() {
        placeImage.addSubview(favButton)
    }
    
    private func addRatingStackViewToImage() {
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
        favButtonConstraints()
        ratingStackViewConstraints()
        ratingBlurViewConstraints()
        ratingLabelConstraints()
        placeNameConstraints()
        showLocationButtonConstraints()
    }
    
    private func placeImageBackgroundConstraints() {
        placeImageBackground.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(safeAreaLayoutGuide).multipliedBy(0.66)
        }
    }
    private func placeImageConstraints() {
        placeImage.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(placeImageBackground)
        }
    }
    
    private func favButtonConstraints() {
        favButton.snp.makeConstraints { make in
            make.trailing.equalTo(placeImage).offset(-10)
            make.top.equalTo(placeImage).offset(10)
            make.height.width.equalTo(placeImage.snp.height).multipliedBy(0.20)
        }
    }
    
    private func ratingStackViewConstraints() {
        ratingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(placeImage).offset(-10)
            make.trailing.equalTo(placeImage).offset(-10)
            make.height.equalTo(placeImage.snp.height).multipliedBy(0.15)
        }
    }
    
    private func ratingBlurViewConstraints() {
        ratingBlurView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(ratingStackView)
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
            make.height.equalTo(placeImage.snp.height).multipliedBy(0.25)
        }
    }
    
    private func showLocationButtonConstraints() {
        showLocationButton.snp.makeConstraints { make in
            make.centerX.equalTo(placeName.snp.centerX)
            make.leading.trailing.equalTo(placeName)
            make.top.equalTo(placeName.snp.bottom).offset(10)
            make.height.equalTo(placeName.snp.height)
            
        }
    }
    
    
}

