//
//  PlaceReviewsView.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit

final class PlaceReviewsView: UIView {

    //MARK: - Creating UI Elements

    let reviewsTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(ReviewsCell.self, forCellReuseIdentifier: ReviewsCell.identifier)
        return tableview
    }()
    
    let noReviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "This place doesn't have reviews."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.addShadow()
        label.isHidden = true
        return label
    }()
    
    let showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show more reviews", for: .normal)
        return button
    }()
    
    
    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure View
    
    private func configureView() {
        backgroundColor = .white
        addSubview()
        setupConstraints()
    }

}

//MARK: - UI Elements AddSubview / Constraints

extension PlaceReviewsView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(reviewsTableView)
        addSubview(noReviewsLabel)
        addSubview(showMoreButton)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        reviewsTableViewConstraints()
        showMoreButtonConstraints()
        noReviewsLabelConstraints()
    }
    
    private func reviewsTableViewConstraints() {
        reviewsTableView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.height.equalTo(self.snp.height).multipliedBy(0.75)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
        }
    }
    
    private func noReviewsLabelConstraints() {
        noReviewsLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
    }
    
    private func showMoreButtonConstraints() {
        showMoreButton.snp.makeConstraints { make in
            make.centerX.equalTo(reviewsTableView.snp.centerX)
            make.top.equalTo(reviewsTableView.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
        }
    }


}

