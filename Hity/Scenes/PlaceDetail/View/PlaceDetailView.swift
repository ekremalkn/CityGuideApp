//
//  PlaceDetailView.swift
//  Hity
//
//  Created by Ekrem Alkan on 5.02.2023.
//

import UIKit
import RxSwift

protocol PlaceDetailViewProtocol {
    var placeDetailViewName: String { get }
    var placeDetailPhotos: [DetailPhoto] { get }
}

final class PlaceDetailView: UIView {
    
    //MARK: - Creating UI Elements
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection  = .horizontal
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        return collection
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.pageIndicatorTintColor = .systemGray
        return pageControl
    }()
    
    private let placeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    let favButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemGray6
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1.5
        return stackView
    }()
    
    let buttonBottomLine1: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.isHidden = true
        return view
    }()
    
    let buttonBottomLine2: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.isHidden = true
        return view
    }()
    
    let buttonBottomLine3: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.isHidden = true
        return view
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Info", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let weekdayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Weekday", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let reviewsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reviews", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    
    //MARK: - Properties
    
    let placeInfoView = PlaceInfoView()
    let placeWeekdaysView = PlaceWeekdaysView()
    let placeReviewsView = PlaceReviewsView()
    
    
    //MARK: - DisposeBag
    
    let disposeBag = DisposeBag()

    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - PageControl CurrentPage
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    
    //MARK: - Configure View
    
    private func configureView() {
        backgroundColor = .white
        addSubview()
        setupConstraints()
        toggleFavButton()
    }
    
    func configure(_ data: PlaceDetailViewProtocol) {
        self.placeName.text = data.placeDetailViewName
        self.pageControl.numberOfPages = data.placeDetailPhotos.count
        
    }
    
    //MARK: - Toogle fav button
    
    func toggleFavButton() {
        let image = UIImage(systemName: "heart")
        let imageFilled = UIImage(systemName: "heart.fill")
        favButton.setImage(image, for: .normal)
        favButton.setImage(imageFilled, for: .selected)
    }
    
    
    //MARK: - According to buttons bottom line will toggle bottom line and view
    func toggleViews(_ bottomLine: UIView) {
        switch bottomLine {
        case buttonBottomLine1:
            buttonBottomLine1.isHidden = false
            placeInfoView.isHidden = false
            buttonBottomLine2.isHidden = true
            placeWeekdaysView.isHidden = true
            buttonBottomLine3.isHidden = true
            placeReviewsView.isHidden = true
        case buttonBottomLine2:
            buttonBottomLine1.isHidden = true
            placeInfoView.isHidden = true
            buttonBottomLine2.isHidden = false
            placeWeekdaysView.isHidden = false
            buttonBottomLine3.isHidden = true
            placeReviewsView.isHidden = true
        case buttonBottomLine3:
            buttonBottomLine1.isHidden = true
            placeInfoView.isHidden = true
            buttonBottomLine2.isHidden = true
            placeWeekdaysView.isHidden = true
            buttonBottomLine3.isHidden = false
            placeReviewsView.isHidden = false
        default:
            return
        }
        
    }
    
    
}

//MARK: - UI Elements AddSubview / Constraints

extension PlaceDetailView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(imageCollectionView)
        addSubview(pageControl)
        addSubview(placeName)
        addSubview(favButton)
        addSubview(buttonStackView)
        buttonsToStackView()
        buttonBottomLineToButtons()
        addSubview(placeInfoView)
        addSubview(placeWeekdaysView)
        addSubview(placeReviewsView)
    }
    
    private func buttonsToStackView() {
        buttonStackView.addArrangedSubview(infoButton)
        buttonStackView.addArrangedSubview(weekdayButton)
        buttonStackView.addArrangedSubview(reviewsButton)
    }
    
    private func buttonBottomLineToButtons() {
        infoButton.addSubview(buttonBottomLine1)
        weekdayButton.addSubview(buttonBottomLine2)
        reviewsButton.addSubview(buttonBottomLine3)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        imageCollectionViewConstraints()
        pageControlConstraints()
        placeNameConstraints()
        saveButtonConstraints()
        buttonStackViewConstraints()
        buttonBottomLineConstraints(infoButton, buttonBottomLine1)
        buttonBottomLineConstraints(weekdayButton, buttonBottomLine2)
        buttonBottomLineConstraints(reviewsButton, buttonBottomLine3)
        placeInfoViewConstraints()
        placeWeekdaysViewConstraints()
        placeReviewsViewConstraints()
    }
    
    private func imageCollectionViewConstraints() {
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
    }
    
    private func pageControlConstraints() {
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(15)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.04666667)
            make.centerX.equalTo(imageCollectionView.snp.centerX)
        }
    }
    
    private func placeNameConstraints() {
        placeName.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.04666667)
            make.leading.equalTo(imageCollectionView)
            make.trailing.equalTo(favButton.snp.leading).offset(-10)
        }
    }
    
    
    private func saveButtonConstraints() {
        favButton.snp.makeConstraints { make in
            make.trailing.equalTo(imageCollectionView)
            make.centerY.equalTo(placeName.snp.centerY)
            make.height.width.equalTo(placeName.snp.height)
        }
    }
    
    private func buttonStackViewConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(placeName.snp.bottom).offset(20)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.04666667)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func buttonBottomLineConstraints(_ button: UIButton, _ buttonBottomLine: UIView) {
        buttonBottomLine.snp.makeConstraints { make in
            make.width.equalTo(button.snp.width)
            make.bottom.equalTo(button.snp.bottom)
            make.height.equalTo(button.snp.height).multipliedBy(0.1)
        }
    }
    
    private func placeInfoViewConstraints() {
        placeInfoView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.trailing.equalTo(imageCollectionView)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func placeWeekdaysViewConstraints() {
        placeWeekdaysView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.trailing.equalTo(imageCollectionView)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func placeReviewsViewConstraints() {
        placeReviewsView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.trailing.equalTo(imageCollectionView)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
}

