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
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
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
        placeholder = "Search"
        layer.cornerRadius = 10
        backgroundColor = UIColor.systemGray6
        leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftView?.tintColor = .systemGray
        leftViewMode = .always
        rightView = sortButton
        rightView?.contentMode = .scaleAspectFit
        rightViewMode = .always
        rightView?.frame.origin.x = -15
    }

}
