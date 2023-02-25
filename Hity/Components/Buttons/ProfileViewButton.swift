//
//  ProfileViewButton.swift
//  Hity
//
//  Created by Ekrem Alkan on 19.02.2023.
//

import UIKit

final class ProfileViewButton: UIButton {
    
    var rightImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    override var imageView: UIImageView? {
        get {
            
            
            return self.rightImage
        }
        
        set {
            if let newValue = newValue {
                self.rightImage = newValue
            }
        }
    }
    
    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Button
    
    private func configureButton() {
        backgroundColor = .clear
        addSubview()
        setupConstraints()
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
}

//MARK: - AddSubview / Constraints

extension ProfileViewButton {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        self.addSubview(rightImage)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        rightImage.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.width.height.equalTo(self.imageView!)
        }
        
        
    }
    
    
    
}
