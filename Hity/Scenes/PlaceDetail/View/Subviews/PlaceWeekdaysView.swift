//
//  PlaceWeekdaysView.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit


final class PlaceWeekdaysView: UIView {
    
    //MARK: - Creating UI Elements
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemGray6
        stackView.spacing = 1.5
        return stackView
    }()
    
    private let day1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let day2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let day3Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let day4Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let day5Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let day6Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private let day7Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .white
        label.textColor = .black
        return label
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
    
    func configure(_ weekdayText: [String]?) {
        if let weekdayText = weekdayText {
            day1Label.text = weekdayText[0]
            day2Label.text = weekdayText[1]
            day3Label.text = weekdayText[2]
            day4Label.text = weekdayText[3]
            day5Label.text = weekdayText[4]
            day6Label.text = weekdayText[5]
            day7Label.text = weekdayText[6]
        } else {
            day1Label.textColor = .systemGray4
            day1Label.text = "Place doesn't have working hours"
        }
        
    }

    
}

//MARK: - UI Elements AddSubView / Constraints

extension PlaceWeekdaysView {
    
    //MARK: - AddSubView
    
    private func addSubview() {
        addSubview(labelStackView)
        dayLabelsToStackView()
    }
    
    private func dayLabelsToStackView() {
        labelStackView.addArrangedSubview(day1Label)
        labelStackView.addArrangedSubview(day2Label)
        labelStackView.addArrangedSubview(day3Label)
        labelStackView.addArrangedSubview(day4Label)
        labelStackView.addArrangedSubview(day5Label)
        labelStackView.addArrangedSubview(day6Label)
        labelStackView.addArrangedSubview(day7Label)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        labelStackViewConstraints()
    }
    
    private func labelStackViewConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(self)
        }
    }
    
    
}

