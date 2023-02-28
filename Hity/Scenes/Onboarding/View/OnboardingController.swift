//
//  OnboardingController.swift
//  Hity
//
//  Created by Ekrem Alkan on 31.01.2023.
//

import UIKit
import RxSwift

final class OnboardingController: UIViewController {
    
    deinit {
        print("deinit onboardingcontroller")
    }
    
    //MARK: - Constants
    
    private let onboardingView = OnboardingView()
    
    //MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - ConfigureViewController
    
    private func configureViewController() {
        view = onboardingView
        customizeNavBar()
        createViewButtonCallbacks()
        configureCollectionView()
    }
    
    private func customizeNavBar() {
        navigationController?.isNavigationBarHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Guide", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    //MARK: - Onboarding View Button Callbacks
    
    private func createViewButtonCallbacks() {
        
        // Got it button
        onboardingView.skipButton.rx.tap.subscribe(onNext: { [weak self] in
            let controller = SignInController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: onboardingView.disposeBag)
        // ContiuneButton
        onboardingView.contiuneButtonTapped.subscribe { [weak self] _ in
            let controller = SignInController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }.disposed(by: onboardingView.disposeBag)
        
        
    }
    
    //MARK: - Configure CollectionView
    
    private func configureCollectionView() {
        
        onboardingView.slides.bind(to: onboardingView.onboardingCollection.rx.items(cellIdentifier: OnboardingCell.identifier, cellType: OnboardingCell.self)) { row, slideData, cell in
            cell.configure(slideData)
        }.disposed(by: onboardingView.disposeBag)
        
        onboardingView.slides.onNext([OnboardingSlide(title: "Choose Location.", subtitle: "Choose the place you want to search around.", image: UIImage(named: "onboarding1") ?? UIImage()),
                                      OnboardingSlide(title: "What's nearby?", subtitle: "Search for what you want to see nearby.", image: UIImage(named: "onboarding2") ?? UIImage()),
                                      OnboardingSlide(title: "List nearby places.", subtitle: "Get all the details of nearby places and add to favorite.", image: UIImage(named: "onboarding33") ?? UIImage())])
        
        onboardingView.onboardingCollection.rx.setDelegate(self).disposed(by: onboardingView.disposeBag)
    }
    
    
}

//MARK: - Collection Cell Size

extension OnboardingController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onboardingView.onboardingCollection.frame.width, height: onboardingView.onboardingCollection.frame.height)
    }
}


//MARK: - Onboarding Collectionview ScrollView Methods

extension OnboardingController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let witdh = scrollView.frame.width
        onboardingView.currentPage = Int(contentOffset) / Int(witdh)
    }
}



