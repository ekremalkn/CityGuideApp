//
//  NearbySearchView.swift
//  Hity
//
//  Created by Ekrem Alkan on 3.02.2023.
//

import UIKit
import RxSwift

final class NearbySearchView: UIView {
    
    //MARK: - Creating UI Elements
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Nearby Search"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    let searchDistanceButton: UIButton = {
        let button = UIButton()
        button.setTitle("about in: 1000m", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let searchDistancePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
 
    let textField = NearbySearchTextField()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        collection.register(NearbyPlacesCell.self, forCellWithReuseIdentifier: NearbyPlacesCell.identifier)
        return collection
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


extension NearbySearchView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(label)
        addSubview(searchDistanceButton)
        addSubview(textField)
        addSubview(collectionView)
    }

    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        labelConstraints()
        distanceButtonConstraints()
        textFieldConstraints()
        collectionViewConstraints()
    }
    
    private func labelConstraints() {
        label.snp.makeConstraints { make in
            make.width.height.equalTo(label)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
        }
    }
    
    private func distanceButtonConstraints() {
        searchDistanceButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.centerY.equalTo(label.snp.centerY)
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

    private func collectionViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    
    
}
