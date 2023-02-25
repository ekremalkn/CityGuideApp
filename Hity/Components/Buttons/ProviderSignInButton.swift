//
//  ProviderSignInButton.swift
//  Hity
//
//  Created by Ekrem Alkan on 25.02.2023.
//

import UIKit

final class ProviderSignInButton: UIButton {

   
    //MARK: - Button Elements
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let providerName: UILabel = {
        let label = UILabel()
        return label
    }()

    override var buttonType: UIButton.ButtonType {
        get {
            return .system
        }
        set {
            
        }
    }
            
    
    override func layoutSubviews() {
        addSubview()
        setupConstraints()
    }
    //MARK: - Init methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    convenience init(_ leftImage: UIImage, _ providerName: String, _ backgroundColor: UIColor, _ titleColor: UIColor) {
        self.init(frame: .zero)
        self.addShadow()
        self.leftImageView.image = leftImage
        self.providerName.text = providerName
        self.backgroundColor = backgroundColor
        self.providerName.textColor = titleColor
        
    }

    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(leftImageView)
        addSubview(providerName)
    }
    
    //MARK: - Setup Constraints

    private func setupConstraints() {
        leftImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self.snp.leading).offset(10)
            make.width.height.equalTo(self.snp.height).multipliedBy(0.75)
        }
        
        providerName.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.centerY.equalTo(self)
            
        }
    }


}
