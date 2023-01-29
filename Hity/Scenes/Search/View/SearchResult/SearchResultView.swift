//
//  SearchResultView.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit

class SearchResultView: UIView {

    //MARK: - Creating UI Elements
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
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
        addSubview()
        setupConstraints()
    }

    


}

//MARK: - UI Elements AddSubview / Constraints

extension SearchResultView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(tableView)
    }
    
    //MARK: - SetupConstraints
    
    private func setupConstraints() {
        tableViewConstraints()
    }
    
    private func tableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }


}

