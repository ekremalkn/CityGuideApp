//
//  OnboardingCell.swift
//  Hity
//
//  Created by Ekrem Alkan on 27.02.2023.
//

import UIKit

final class OnboardingCell: UICollectionViewCell {
    
    //MARK: - Cell's Identifier
    
    static let identifier = "OnboardingCell"
    
    //MARK: - Creating UI Elements
    
    private var onboardingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private var slideTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var slideSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
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
    
    //MARK: - ConfigureCell
    
    private func configureCell() {
        isUserInteractionEnabled = false
        addSubview()
        setupConstraints()
    }
    
    //MARK: - Configure
    
    func configure(_ data: OnboardingSlide) {
        onboardingImageView.image = data.image
        slideTitleLabel.text = data.title
        slideSubtitleLabel.text = data.subtitle
    }
    
    
    
    
}

//MARK: - UI Elements AddSubview / Constraints

extension OnboardingCell {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(onboardingImageView)
        addSubview(labelStackView)
        labelsToStackView()
    }
    
    private func labelsToStackView() {
        labelStackView.addArrangedSubview(slideTitleLabel)
        labelStackView.addArrangedSubview(slideSubtitleLabel)
    }
    
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        onboardingImageViewConstraints()
        labelStackViewConstraints()
    }
    
    
    private func onboardingImageViewConstraints() {
        onboardingImageView.snp.makeConstraints { make in
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.75)
            make.width.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func labelStackViewConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(onboardingImageView.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(15)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}

