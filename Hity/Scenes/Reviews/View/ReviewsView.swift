//
//  ReviewsView.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit
import RxSwift

final class ReviewsView: UIView {

    //MARK: - Creating UI Elements
    
    let sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        return button
    }()
    
    let reviewsTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(ReviewsCell.self, forCellReuseIdentifier: ReviewsCell.identifier)
        return tableview
    }()
    
    //MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()
    
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

extension ReviewsView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(reviewsTableView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        reviewsTableViewConstraints()
    }
    
    private func reviewsTableViewConstraints() {
        reviewsTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }


}

