//
//  DistancePopUpView.swift
//  Hity
//
//  Created by Ekrem Alkan on 24.02.2023.
//

import UIKit
import RxSwift

final class DistancePopUpView: UIView {

    //MARK: - Creating UI Elements
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.addShadow()
        return view
    }()
    
    let topGrabber: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Set distance:"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    let distanceSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.maximumValue = 20
        slider.value = 10
        return slider
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    
    let setButton: CircleButton = {
        let button = CircleButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Set Distance", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()

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
        backgroundColor = .clear
        addSubview()
        setupConstraints()
    }


}


//MARK: - UI Elements AddSubview / Constraints

extension DistancePopUpView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(emptyView)
        addSubview(contentView)
        elementsToContentView()
    }
    
    private func elementsToContentView() {
        contentView.addSubview(topGrabber)
        contentView.addSubview(titleLabel)
        contentView.addSubview(distanceSlider)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(setButton)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        contentViewConstraints()
        topGrabberConstraints()
        titleLabelConstraints()
        distanceSliderConstraints()
        setButtonConstraints()
        distanceLabelConstraints()
    }

    private func emptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(self.snp.height).multipliedBy(0.7)
        }
    }
    
    private func contentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.bottom)
            make.bottom.trailing.leading.equalTo(self)
        }
    }
    
    private func topGrabberConstraints() {
        topGrabber.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.top.equalTo(contentView.snp.top).offset(3)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.15)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    private func titleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topGrabber.snp.bottom)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.15)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
        }
    }
    
    
    private func distanceSliderConstraints() {
        distanceSlider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.3)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.75)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    
    private func setButtonConstraints() {
        setButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-30)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.2)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.4)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    private func distanceLabelConstraints() {
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceSlider.snp.bottom)
            make.bottom.equalTo(setButton.snp.top)
            make.leading.trailing.equalTo(distanceSlider)
        }
    }
    
    
    

    
}

