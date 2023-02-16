//
//  PlaceInfoView.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit

final class PlaceInfoView: UIView {

    //MARK: - Creating UI Elements
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1.5
        stackView.backgroundColor = .systemGray6
        return stackView
    }()
 
    let address: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    let openingHours: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "clock"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    let website: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "globe"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    let phoneNumber: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "phone"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .blue
        return button
    }()

    //MARK: - Init methods
    
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
    
    func configure(_ data: DetailResults) {
        if let address = data.formattedAddress {
            self.address.setTitle(address, for: .normal)
        }
        
        if let openingHours = data.currentOpeningHours?.openNow {
            if openingHours {
                self.openingHours.setTitleColor(.green, for: .normal)
                self.openingHours.setTitle("Open", for: .normal)
            } else {
                self.openingHours.setTitleColor(.red, for: .normal)
                self.openingHours.setTitle("Closed", for: .normal)
            }
        }
        
        if let website = data.website {
            self.website.setTitle(website, for: .normal)
        } else {
            self.website.setTitle("Workplace doesn't have a website / didn't share.", for: .normal)
        }
        
        if let phoneNumber = data.internationalPhoneNumber {
            self.phoneNumber.setTitle(phoneNumber, for: .normal)
        } else {
            self.phoneNumber.setTitle("Workplace doesn't have a phone number / didn't share.", for: .normal)
        }
    }


}

//MARK: - UI Elements Addsubview / Constraints

extension PlaceInfoView {
    
    //MARK: - Addsubview
    
    private func addSubview() {
        addSubview(buttonStackView)
        buttonsToStackView()
    }
    
    private func buttonsToStackView() {
        buttonStackView.addArrangedSubview(address)
        buttonStackView.addArrangedSubview(openingHours)
        buttonStackView.addArrangedSubview(website)
        buttonStackView.addArrangedSubview(phoneNumber)
    }

    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        buttonStackViewConstraints()
    }
    
    private func buttonStackViewConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(self)
        }
    }
 

    


}
