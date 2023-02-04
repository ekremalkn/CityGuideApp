//
//  NearbySearchView.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import UIKit

final class NearbySearchView: UIView {
    
    //MARK: - Creating UI Elements
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Seçtiğin konumun yakınında bir yer ara. Orneğin: 'Eczane, Spor Salonu vb.'"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Yakınında ne aramak istersin?"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor.systemGray6
        textField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        textField.leftView?.tintColor = .systemGray6
        textField.leftViewMode = .always
        return textField
    }()
    
    
    let tableView: UITableView = {
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
    
    //MARK: - Configure View
    
    private func configureView() {
        addSubview()
        setupConstraints()
    }
    
    
    
}

//MARK: - UI Elements AddSubview / Constraints


extension NearbySearchView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(label)
        addSubview(textField)
        addSubview(tableView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        labelConstraints()
        textFieldConstraints()
        tableViewConstraints()
    }
    
    private func labelConstraints() {
        label.snp.makeConstraints { make in
            make.width.height.equalTo(label)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
        }
    }
    
    private func textFieldConstraints() {
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.top.equalTo(label.snp.bottom).offset(20)
            
        }
    }
    
    private func tableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
