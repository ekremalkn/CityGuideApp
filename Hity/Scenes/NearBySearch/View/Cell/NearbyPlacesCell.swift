//
//  NearbyPlacesCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 4.02.2023.
//

import UIKit

protocol NearbyPlacesCellProtocol {
    var placeImage: String { get }
    var placeName: String { get }
    var placeAddress: String { get }
    var placeOpenClosedInfo: String { get }
    var placeRating: String { get }
    var placeTotalRatings: String { get }

}

final class NearbyPlacesCell: UITableViewCell {
    
    //MARK: - Cell's Identifier
    
    static let identifier = "NearbyPlacesCell"
    
    //MARK: - Creating UI Elements
    
    lazy var placeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    lazy var placeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var placeAddress: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var placeOpenClosedInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var placeRating: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var userRatingsTotal: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    
    //MARK: - Init Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Confgure Cell
    
    private func configureCell() {
        backgroundColor = .clear
        addSubview()
        setupConstraints()
    }
    
    func configure(_ data: NearbyPlacesCellProtocol) {
        self.placeImage.downloadSetImage(url: data.placeImage)
        self.placeName.text = data.placeName
        self.placeAddress.text = data.placeAddress
        self.placeOpenClosedInfo.text = data.placeOpenClosedInfo
        self.placeRating.text = data.placeRating
        userRatingsTotal.text = data.placeTotalRatings
    }
    
    
}

//MARK: - UI Elements Addsubview / Constraints

extension NearbyPlacesCell {
    
    //MARK: - Addsubview
    
    private func addSubview() {
        addSubview(placeImage)
        addSubview(placeName)
        addSubview(placeAddress)
        addSubview(placeOpenClosedInfo)
        addSubview(placeRating)
        addSubview(userRatingsTotal)
        
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        placeImageConstraints()
        placeNameConstraints()
        placeAddressConstraints()
        placeOpenClosedInfoConstraints()
        placeRatingConstraints()
        userRatingsTotalConstraints()
    }
    
    private func placeImageConstraints() {
        placeImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(placeImage.snp.height)
        }
    }
    
    private func placeNameConstraints() {
        placeName.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(placeImage.snp.trailing).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func placeAddressConstraints() {
        placeAddress.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(5)
            make.leading.trailing.equalTo(placeName)
        }
    }
    
    private func placeOpenClosedInfoConstraints() {
        placeOpenClosedInfo.snp.makeConstraints { make in
            make.top.equalTo(placeAddress.snp.bottom).offset(5)
            make.leading.trailing.equalTo(placeName)
        }
    }
    
    private func placeRatingConstraints() {
        placeRating.snp.makeConstraints { make in
            make.top.equalTo(placeOpenClosedInfo.snp.bottom).offset(5)
            make.leading.equalTo(placeName)
            make.width.equalTo(placeRating.snp.width)
        }
    }
    
    private func userRatingsTotalConstraints() {
        userRatingsTotal.snp.makeConstraints { make in
            make.centerY.equalTo(placeRating)
            make.leading.equalTo(placeRating.snp.trailing).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
