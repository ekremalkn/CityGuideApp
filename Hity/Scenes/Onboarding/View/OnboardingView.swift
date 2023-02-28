//
//  OnboardingView.swift
//  Hity
//
//  Created by Ekrem Alkan on 31.01.2023.
//

import UIKit
import RxSwift

final class OnboardingView: UIView {
    
    deinit {
        print("deinit onboardingview")
    }
    //MARK: - Creating UI Elements
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    let onboardingCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.pageIndicatorTintColor = .systemGray
        return pageControl
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let contiuneButton: CircleButton = {
        let button = CircleButton(type: .system)
        button.setTitle("Contiune", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.backgroundColor = .blue
        return button
    }()
    
    let skipButton: CircleButton = {
        let button = CircleButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    //MARK: - Observable Variables
    
    let contiuneButtonTapped = PublishSubject<Void>()
    
    //MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()
    
    //MARK: - Onboarding Model Array
    
    var slides = PublishSubject<[OnboardingSlide]>()
    var slideForPageControl: [OnboardingSlide] = []
    
    //MARK: - PageControl CurrentPage
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slideForPageControl.count - 1 {
                UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
                    self?.skipButton.isHidden = true
                    self?.contiuneButton.setTitle("Get started", for: .normal)
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
                    self?.skipButton.isHidden = false
                    self?.contiuneButton.setTitle("Contiune", for: .normal)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        skipButton.layer.cornerRadius = skipButton.frame.height / 2
        skipButton.layer.masksToBounds = true
    }
    
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
        backgroundColor = .white
        addSubview()
        setupConstraints()
        createContinuneButtonCallback()
        setSlides()
        pageControl.numberOfPages = slideForPageControl.count
    }
    
    //MARK: - Set Slides
    
    func setSlides() {
        slideForPageControl = [OnboardingSlide(title: "", subtitle: "", image: UIImage()),
                               OnboardingSlide(title: "", subtitle: "", image: UIImage()),
                               OnboardingSlide(title: "", subtitle: "", image: UIImage())]
    }
    
    //MARK: - Contiune Button Callback
    
    private func createContinuneButtonCallback() {
        contiuneButton.rx.tap.subscribe(onNext: { [unowned self] in
            if self.currentPage == self.slideForPageControl.count - 1 {
                self.contiuneButtonTapped.onNext(())
            } else {
                self.onboardingCollection.isPagingEnabled = false
                self.currentPage += 1
                let indexPath = IndexPath(item: self.currentPage, section: 0)
                self.onboardingCollection.scrollToItem(at: indexPath, at: .right, animated: true)
                self.onboardingCollection.isPagingEnabled = true
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    
}


//MARK: - UI Elements Addsubview / Constraints

extension OnboardingView {
    
    //MARK: - Addsubview
    
    private func addSubview() {
        addSubview(emptyView)
        addSubview(onboardingCollection)
        addSubview(buttonStackView)
        buttonsToStackView()
    }
    
    private func buttonsToStackView() {
        buttonStackView.addArrangedSubview(pageControl)
        buttonStackView.addArrangedSubview(contiuneButton)
        buttonStackView.addArrangedSubview(skipButton)
    }
    //MARK: - SetupConstraints
    
    private func setupConstraints() {
        emptyViewConstraints()
        onboardingCollectionConstraints()
        buttonStackViewConstraints()
    }
    
    private func emptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.013333335)
        }
    }
    
    private func onboardingCollectionConstraints() {
        onboardingCollection.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.75)
        }
    }
    
    private func buttonStackViewConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(onboardingCollection.snp.bottom).offset(20)
            make.centerX.equalTo(onboardingCollection.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
    
}

