//
//  NearbyPlacesCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 5.02.2023.
//

import UIKit
import CoreLocation
import RxSwift

protocol NearbyPlacesCellProtocol {
    var placeUID: String { get }
    var placeLocation: CLLocationCoordinate2D { get }
    var placeImage: String { get}
    var placeName: String { get }
    var placeRating: String { get }
    var placeRatingTotal: String { get }
    var placeAddress: String { get }
    var placeOpenClosedInfo: Bool { get }
}

protocol NearbyPlacesCellInterface: AnyObject {
    func didTapDetailsButton(_ view: NearbyPlacesCell, _ placeUID: String)
    func didTapLocationButton(_ view: NearbyPlacesCell, _ coordinates: CLLocationCoordinate2D, _ placeName: String, _ placeImage: String)
}

final class NearbyPlacesCell: UICollectionViewCell {
    
    
    //MARK: - Cell's Identifier
    
    static let identifier = "NearbyPlacesCell"
    
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
    
    private let placeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
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
    
    private let distanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private let distanceImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private var placeOpenClosedInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let showLocationButton: CircleButton = {
        let button = CircleButton(type: .custom)
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.tintColor = .darkGray
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .systemGray6
        button.addShadow()
        return button
    }()
    
    let showDetailsButton: CircleButton = {
        let button = CircleButton(type: .custom)
        button.setImage(UIImage(systemName: "info"), for: .normal)
        button.tintColor = .blue
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .systemGray6
        button.addShadow()
        return button
    }()
    
    let favButton: CircleButton = {
        let button = CircleButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .darkGray
        
        button.backgroundColor = .systemGray6
        button.addShadow()
        return button
    }()
    
    let userRatingTotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    //MARK: - Properties
    weak var interace: NearbyPlacesCellInterface?
    private let nearBySearchViewModel = NearbySearchViewModel()
    let disposeBag = DisposeBag()
    
     // observable variables
    
    var favButtonTap: Observable<Void> {
        return self.favButton.rx.tap.asObservable()
    }
   
    
    //MARK: - Variables
    
    var placeUID: String?
    var locations: CLLocationCoordinate2D?
    var address: String?
    var placeImageURL: String!
    
    //MARK: - Init methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - Configure Cell
    
    private func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 25
        addSubview()
        setupConstraints()
        addTarget()
        toggleFavButton()
    }
    
    //MARK: - Calculate distance between Main Location and NearPlace Location
    
    private func calculateDistance(_ mainLocation: CLLocation?, _ nearPlaceLocation: CLLocationCoordinate2D) -> Int{
        if let mainLocation = mainLocation {
            let nearPlace = CLLocation(latitude: nearPlaceLocation.latitude, longitude: nearPlaceLocation.longitude)
            let distance = mainLocation.distance(from: nearPlace)
            return Int(round(distance))
        }
        return Int()
    }
    
    //MARK: - Open / Closed Check
    
    private func openClosedCheck(_ openNow: Bool, _ placeOpenClosedInfoLbl: UILabel) -> UILabel {
        switch openNow {
        case true:
            placeOpenClosedInfoLbl.text = "Open"
            placeOpenClosedInfoLbl.textColor = .green
            return placeOpenClosedInfoLbl
        case false:
            placeOpenClosedInfoLbl.text = "Closed"
            placeOpenClosedInfoLbl.textColor = .red
            return placeOpenClosedInfoLbl
        default:
            placeOpenClosedInfoLbl.text = "Unknown"
            placeOpenClosedInfoLbl.textColor = .black
            return placeOpenClosedInfoLbl
        }
        
    }
    
    
    
    func configure(_ data: NearbyPlacesCellProtocol, _ mainLocation: CLLocation? = nil) {
        self.placeUID = data.placeUID
        self.locations = data.placeLocation
        self.placeImageURL = data.placeImage
        self.placeImage.downloadSetImage(type: .photoReference, url: data.placeImage)
        self.placeName.text = data.placeName
        self.ratingLabel.text = data.placeRating
        self.distanceLabel.text = "\(self.calculateDistance(mainLocation, data.placeLocation))m"
        self.placeOpenClosedInfo = self.openClosedCheck(data.placeOpenClosedInfo, placeOpenClosedInfo)
        self.userRatingTotalLabel.text = data.placeRatingTotal
    }
    
    //MARK: - Toogle fav button

    func toggleFavButton() {
        let image = UIImage(systemName: "heart")
        let imageFilled = UIImage(systemName: "heart.fill")
        favButton.setImage(image, for: .normal)
        favButton.setImage(imageFilled, for: .selected)
    }
    
    //MARK: - AddAction to Button
    
    private func addTarget() {
        showDetailsButton.addTarget(self, action: #selector(tapDetailsButton), for: .touchUpInside)
        showLocationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
    }
    
    @objc private func tapDetailsButton(_ button: UIButton) {
        if let placeUID = placeUID {
            self.interace?.didTapDetailsButton(self, placeUID)
        }
    }
    
    @objc private func tapLocationButton(_ button: UIButton) {
        if let locations = locations {
            if let placeName = placeName.text {
                self.interace?.didTapLocationButton(self, locations, placeName, placeImageURL)
            } else {
                self.interace?.didTapLocationButton(self, locations, "", placeImageURL)
            }
        }
    }
    
    
}

//MARK: - UI Elements Addsubview / Constraints

extension NearbyPlacesCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(placeImageBackground)
        placeImageToBackgroundView()
        ratingStackViewToPlaceImage()
        ratingElementsToStackView()
        ratingBlurViewToStackView()
        addSubview(placeName)
        addSubview(distanceStackView)
        distanceElementsToStackView()
        addSubview(placeOpenClosedInfo)
        addSubview(buttonStackView)
        buttonsToStackView()
        addSubview(userRatingTotalLabel)
        
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
    
    private func distanceElementsToStackView() {
        distanceStackView.addArrangedSubview(distanceImage)
        distanceStackView.addArrangedSubview(distanceLabel)
    }
    
    private func buttonsToStackView() {
        buttonStackView.addArrangedSubview(showDetailsButton)
        buttonStackView.addArrangedSubview(showLocationButton)
        buttonStackView.addArrangedSubview(favButton)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        placeImageBackgroundConstraints()
        placeImageConstraints()
        ratingStackViewConstraints()
        ratingBlurViewConstraints()
        placeNameConstraints()
        distanceStackViewConstraints()
        placeOpenClosedInfoConstraints()
        placeOpenClosedInfoConstraints()
        buttonStackViewConstraints()
        userRatingTotalLabelConstraints()
    }
    
    private func placeImageBackgroundConstraints() {
        placeImageBackground.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
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
    
    private func placeNameConstraints() {
        placeName.snp.makeConstraints { make in
            make.top.equalTo(placeImageBackground.snp.bottom).offset(10)
            make.leading.equalTo(placeImageBackground.snp.leading)
            make.trailing.equalTo(placeImageBackground.snp.trailing)
//            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.15)
        }
    }
    
    private func distanceStackViewConstraints() {
        distanceStackView.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(10)
            make.leading.equalTo(placeName.snp.leading)
        }
    }
    private func placeOpenClosedInfoConstraints() {
        placeOpenClosedInfo.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(10)
            make.centerY.equalTo(distanceStackView.snp.centerY)
            make.trailing.equalTo(placeImageBackground.snp.trailing)
            make.width.equalTo(placeOpenClosedInfo.snp.width)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.04666667)
            
        }
    }
    
    private func buttonStackViewConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(placeOpenClosedInfo.snp.bottom).offset(10)
            make.height.equalTo(placeImageBackground.snp.width).multipliedBy(0.30)
            make.leading.trailing.equalTo(placeImageBackground)
        }
        
    }
    
    private func userRatingTotalLabelConstraints() {
        userRatingTotalLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(10)
        }
    }
    
    
}
