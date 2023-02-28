//
//  NearbySearchTextField.swift
//  Hity
//
//  Created by Ekrem Alkan on 21.02.2023.
//

import UIKit

final class NearbySearchTextField: UITextField {
    
    //MARK: - Creating UI Elements

    let sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
  
    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    //MARK: - Configure TextField

    private func configureTextField() {
        placeholder = "What are you looking for nearby?"
        layer.cornerRadius = 10
        backgroundColor = UIColor.systemGray6
        leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftView?.tintColor = .systemGray
        leftViewMode = .always
        rightView = sortButton
        rightViewMode = .always
    }

    
    
}
