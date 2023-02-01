//
//  OnboardingView.swift
//  Hity
//
//  Created by Ekrem Alkan on 31.01.2023.
//

import UIKit

protocol OnboardingInterface: AnyObject {
    func onboardingView(_ view: OnboardingView, buttonTapped button: UIButton)
}

final class OnboardingView: UIView {

    //MARK: - Creating UI Elements
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Go to map", for: .normal)
        return button
    }()
    
    //MARK: - Properties

    weak var interface: OnboardingInterface?
 
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
        addTarget()
    }
    
    //MARK: - AddAction
    
    private func addTarget() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ button: UIButton) {
        self.interface?.onboardingView(self, buttonTapped: button)
    }

}


//MARK: - UI Elements Addsubview / Constraints

extension OnboardingView {
    
    //MARK: - Addsubview
    
    private func addSubview() {
        addSubview(button)
    }
    
    //MARK: - SetupConstraints

    private func setupConstraints() {
        buttonConstraints()
    }
    
    private func buttonConstraints() {
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(safeAreaLayoutGuide)
        }
    }

}

