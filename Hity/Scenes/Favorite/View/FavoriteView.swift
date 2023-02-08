//
//  FavoriteView.swift
//  Hity
//
//  Created by Ekrem Alkan on 8.02.2023.
//

import UIKit

final class FavoriteView: UIView {

    //MARK: - Creatin UI Elements
    
    lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifier)
        collection.backgroundColor = .blue
        return collection
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

extension FavoriteView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(favoriteCollectionView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        favoriteCollectionViewConstraints()
    }
    
    private func favoriteCollectionViewConstraints() {
        favoriteCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }


}

