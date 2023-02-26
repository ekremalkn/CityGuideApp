//
//  ReviewsCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit

protocol ReviewsCellProtocol {
    var reviewAuthorImage: String { get }
    var reviewAuthorName: String { get }
    var reviewAuthorRating: String { get }
    var reviewRelativeTime: String { get }
    var reviewAuthorText: String { get }
    var reviewTime: Int { get }
}
final class ReviewsCell: UITableViewCell {
    
    //MARK: - Cell's Identifier
    
    static let identifier = "ReviewsCell"
    
    //MARK: - Creating UI Elements
    
    
    let expandableView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    
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
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.backgroundColor = .clear
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
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let authorTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .black
        label.sizeToFit()
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
    
    func configure(_ data: ReviewsCellProtocol) {
        authorImageView.downloadSetImage(type: .onlyURL, url: data.reviewAuthorImage)
        authorName.text = data.reviewAuthorName
        ratingLabel.text = data.reviewAuthorRating
        relativeTimeDescription.text = data.reviewRelativeTime
        authorTextLabel.text = data.reviewAuthorText
    }
    
    //MARK: - Expandable View Animate
    
    func expandableViewAnimate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    
    
}

//MARK: - UI Elements AddSubview / Constraints

extension ReviewsCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        cellElementsToExpandableView()
        contentView.addSubview(expandableView)
    }
    
    private func cellElementsToExpandableView() {
        expandableView.addSubview(authorImageView)
        expandableView.addSubview(authorName)
        expandableView.addSubview(ratingTimeStackView)
        ratingRelativeTimeToStackView()
        ratingElementsToStackView()
        expandableView.addSubview(authorTextLabel)
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
        expandableViewConstraints()
    }
    
    private func authorImageViewConstraints() {
        authorImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(expandableView).offset(15)
            make.height.width.equalTo(expandableView.snp.height).multipliedBy(0.2)
        }
    }
    
    private func authorNameConstraints() {
        authorName.snp.makeConstraints { make in
            make.leading.equalTo(authorImageView.snp.trailing).offset(10)
            make.top.equalTo(authorImageView.snp.top)
            make.height.equalTo(authorImageView.snp.height).multipliedBy(0.5)
        }
    }
    
    private func ratingTimeStackViewConstraints() {
        ratingTimeStackView.snp.makeConstraints { make in
            make.leading.equalTo(authorName.snp.leading)
            make.top.equalTo(authorName.snp.bottom).offset(5)
        }
    }
    
    private func ratingImageConstraints() {
        ratingImage.snp.makeConstraints { make in
            make.height.equalTo(ratingStackView.snp.height)
        }
    }
    
    private func authorTextLabelConstraints() {
        authorTextLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(7)
            make.leading.equalTo(authorImageView.snp.leading)
            make.trailing.equalTo(expandableView.snp.trailing).offset(-15)
            make.bottom.equalTo(expandableView.snp.bottom)
        }
    }
    
    private func expandableViewConstraints() {
        expandableView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    
    
}

