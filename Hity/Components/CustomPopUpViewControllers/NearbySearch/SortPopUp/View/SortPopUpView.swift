//
//  SortPopUpView.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import UIKit
import RxSwift

final class SortPopUpView: UIView {
    
    //MARK: - Creating UI Elements
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.addShadow()
        return view
    }()
    
    let topGrabber: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sorted by:"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SortPopUpCell.self, forCellReuseIdentifier: SortPopUpCell.identifier)
        return tableView
    }()
    
    //MARK: - Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topGrabber.layer.cornerRadius = topGrabber.frame.height / 2
        topGrabber.layer.masksToBounds = true
    }
    
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
    
    
    //MARK: - ConfigureView
    
    private func configureView() {
        backgroundColor = .clear
        addSubview()
        setupConstraints()
    }
    
}

//MARK: - UI Elements AddSubview / Constraints

extension SortPopUpView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(emptyView)
        addSubview(contentView)
        elementsToContentView()
    }
    
    private func elementsToContentView() {
        contentView.addSubview(topGrabber)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tableView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        contentViewConstraints()
        topGrabberConstraints()
        titleLabelConstraints()
        tableViewConstraints()
    }
    
    private func emptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(self.snp.height).multipliedBy(0.70)
        }
    }
    
    private func contentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.bottom)
            make.bottom.trailing.leading.equalTo(self)
        }
    }
    
    private func topGrabberConstraints() {
        topGrabber.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.top.equalTo(contentView.snp.top).offset(7)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.10)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    private func titleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topGrabber.snp.bottom)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.15)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
        }
    }
    
    private func tableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
}

