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
    var placeAddress: String { get }
    var placeOpenClosedInfo: String { get }
}

protocol NearbyPlacesCellInterface: AnyObject {
    func didTapDetailsButton(_ view: NearbyPlacesCell, _ placeUID: String)
    func didTapLocationButton(_ view: NearbyPlacesCell, _ coordinates: CLLocationCoordinate2D)
}

final class NearbyPlacesCell: UICollectionViewCell {
    
    
    //MARK: - Cell's Identifier
    
    static let identifier = "NearbyPlacesCell"
    
    //MARK: - Creating UI Elements
    
    private let placeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let placeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let placeOpenClosedInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
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
    
    private let placeAddress: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .black
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let showLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Konum", for: .normal)
        return button
    }()
    
    let showDetailsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Detay", for: .normal)
        return button
    }()
    
    //MARK: - Properties
    weak var interace: NearbyPlacesCellInterface?
    private let nearBySearchViewModel = NearbySearchViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Variables
    
    var placeUID: String?
    var locations: CLLocationCoordinate2D?
    var name: String?
    var address: String?
    
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
        backgroundColor = .systemGray6
        addSubview()
        setupConstraints()
        addTarget()
    }

    func configure(_ data: NearbyPlacesCellProtocol) {
        self.placeUID = data.placeUID
        self.locations = data.placeLocation
        self.placeImage.downloadSetImage(url: data.placeImage)
        self.placeName.text = data.placeName
        self.placeOpenClosedInfo.text = data.placeOpenClosedInfo
        self.placeAddress.text = data.placeAddress
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
            self.interace?.didTapLocationButton(self, locations)
        }
    }


}

//MARK: - UI Elements Addsubview / Constraints

extension NearbyPlacesCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(placeImage)
        addSubview(placeName)
        addSubview(placeOpenClosedInfo)
        addSubview(placeAddressView)
        addressAndImageToView()
        addSubview(buttonStackView)
        buttonsToStackView()
        
    }
    
    private func addressAndImageToView() {
        placeAddressView.addSubview(placeAdressImage)
        placeAddressView.addSubview(placeAddress)
    }
    
    private func buttonsToStackView() {
        buttonStackView.addArrangedSubview(showDetailsButton)
        buttonStackView.addArrangedSubview(showLocationButton)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        placeImageConstraints()
        placeNameConstraints()
        placeOpenClosedInfoConstraints()
        placeAddressViewConstraints()
        placeAddressImageConstraints()
        placeAddressConstraints()
        buttonStackViewConstraints()
    }
    
    private func placeImageConstraints() {
        placeImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
    }
    
    private func placeNameConstraints() {
        placeName.snp.makeConstraints { make in
            make.top.equalTo(placeImage.snp.bottom).offset(10)
            make.leading.equalTo(placeImage.snp.leading)
            make.trailing.equalTo(placeOpenClosedInfo.snp.leading).offset(-5)
            make.height.equalTo(placeName.snp.height)
        }
    }
    
    private func placeOpenClosedInfoConstraints() {
        placeOpenClosedInfo.snp.makeConstraints { make in
            make.centerY.equalTo(placeName.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.width.equalTo(placeOpenClosedInfo.snp.width)
        }
    }

    private func placeAddressViewConstraints() {
        placeAddressView.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(10)
            make.leading.equalTo(placeName.snp.leading)
            make.trailing.equalTo(placeName.snp.trailing)
            make.height.equalTo(placeAddress.snp.height)
        }
    }
    
    private func placeAddressImageConstraints() {
        placeAdressImage.snp.makeConstraints { make in
            make.centerY.equalTo(placeAddressView.snp.centerY)
            make.leading.equalTo(placeName.snp.leading).offset(5)
            make.width.height.equalTo(placeAddressView.snp.height)
        }
    }
    
    private func placeAddressConstraints() {
        placeAddress.snp.makeConstraints { make in
            make.centerY.equalTo(placeAddressView.snp.centerY)
            make.leading.equalTo(placeAdressImage.snp.trailing).offset(10)
            make.trailing.equalTo(placeAddressView.snp.trailing).offset(-5)
        }
    }
    
    private func buttonStackViewConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(placeAddressView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(placeImage)
            make.height.equalTo(58)
        }
    }
    


    
}
