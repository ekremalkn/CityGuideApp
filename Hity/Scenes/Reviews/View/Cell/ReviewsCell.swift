//
//  ReviewsCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit

protocol ReviewsCellProtocol {
    var image: String { get }
    var author: String { get }
    var authorRating: String { get }
    var relativeTime: String { get }
    var authorText: String { get }
}
final class ReviewsCell: UITableViewCell {

    //MARK: - Cell's Identifier
    
    static let identifier = "ReviewsCell"

    //MARK: - Creating UI Elements
    
    private let authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let authorName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let ratingTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.backgroundColor = .white
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private let relativeTimeDescription: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let authorTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
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
    
    //MARK: - Configure Cell
    
    private func configureCell() {
        addSubview()
        setupConstraints()
    }
    
    func configure(_ data: DetailReview) {
        authorImageView.downloadSetImage(type: .onlyURL, url: data.image)
        authorName.text = data.author
        ratingLabel.text = data.authorRating
        relativeTimeDescription.text = data.relativeTime
        authorTextLabel.text = data.authorText
    }

    
}

//MARK: - UI Elements AddSubview / Constraints

extension ReviewsCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(authorImageView)
        addSubview(authorName)
        addSubview(ratingTimeStackView)
        ratingRelativeTimeToStackView()
        ratingElementsToStackView()
        addSubview(authorTextLabel)
    }
    
    private func ratingRelativeTimeToStackView() {
        ratingTimeStackView.addArrangedSubview(ratingStackView)
        ratingTimeStackView.addArrangedSubview(relativeTimeDescription)
    }
    
    private func ratingElementsToStackView() {
        ratingStackView.addArrangedSubview(ratingImage)
        ratingStackView.addArrangedSubview(ratingLabel)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        authorImageViewConstraints()
        authorNameConstraints()
        ratingTimeStackViewConstraints()
        ratingImageConstraints()
        authorTextLabelConstraints()
    }

    private func authorImageViewConstraints() {
        authorImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).offset(15)
            make.height.width.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.2)
        }
    }
    
    private func authorNameConstraints() {
        authorName.snp.makeConstraints { make in
            make.leading.equalTo(authorImageView.snp.trailing).offset(10)
            make.centerY.equalTo(authorImageView.snp.centerY)
        }
    }
    
    private func ratingTimeStackViewConstraints() {
        ratingTimeStackView.snp.makeConstraints { make in
            make.top.equalTo(authorImageView.snp.bottom).offset(10)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.1)
        }
    }
    
    private func ratingImageConstraints() {
        ratingImage.snp.makeConstraints { make in
            make.height.equalTo(ratingStackView.snp.height)
        }
    }
    
    private func authorTextLabelConstraints() {
        authorTextLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(10)
            make.leading.equalTo(authorImageView.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}

