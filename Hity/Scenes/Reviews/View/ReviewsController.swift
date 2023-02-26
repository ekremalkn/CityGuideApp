//
//  ReviewsController.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit
import RxSwift

final class ReviewsController: UIViewController {

    //MARK: - PopUp View Controllers
    
    let reviewsSortPopUpController = ReviewsSortPopUpController()

    //MARK: - Constants

    private let reviewsView = ReviewsView()
    private let reviewsViewModel = ReviewsViewModel()
    
    //MARK: - DisposeBag

    private let disposeBag = DisposeBag()
    
    // sort variables
    var sortType: ReviewsSortTypesTitle?
    
    //MARK: - Variables

    var placeUID: String
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    //MARK: - Init Methods
    
    init(placeUID: String) {
        self.placeUID = placeUID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view = reviewsView
        customizeNavBar()
        createCallbacks()
    }
    
    private func customizeNavBar() {
        title = "Reviews"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reviewsView.sortButton)
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        createTableViewCallbacks()
        createReviewsButtonCallbacks()
    }

    
    //MARK: - Reviews View Button Callbacks
    
    private func createReviewsButtonCallbacks() {
        
        // Sort Button
        reviewsView.sortButton.rx.tap.bind { [unowned self] in
            reviewsSortPopUpController.presentPopUpController(self)
        }.disposed(by: reviewsView.disposeBag)
        
        //TableView Cell Selected
        reviewsSortPopUpController.tableViewCellSelected.subscribe { [weak self]  sortTypeTitle in
            switch sortTypeTitle {
                
            case .next(let sortType):
                self?.sortType = sortType
                self?.reviewsViewModel.fetchPlaceReviews(self?.placeUID ?? "", sortType: sortType)
            default:
                break
            }
        }.disposed(by: reviewsSortPopUpController.disposeBag)
    }

    //MARK: - TableView Callbacks
    
    private func createTableViewCallbacks() {
        
        //bind placereviews to tableview
        reviewsViewModel.placeReviews.bind(to: reviewsView.reviewsTableView.rx.items(cellIdentifier: ReviewsCell.identifier, cellType: ReviewsCell.self)) { row, placeReviews, cell in
            cell.configure(placeReviews)
            cell.expandableViewAnimate()
        }.disposed(by: disposeBag)
        
        
        //fetch placereviews
        
        self.reviewsViewModel.fetchPlaceReviews(placeUID, sortType: .logic)
        
        //handle did select
        
//        reviewsView.reviewsTableView.rx.modelSelected(DetailReview.self).bind(onNext: { placeReviews in
//            if let authorProfileURL = placeReviews.authorURL {
//                guard let URL = URL(string: authorProfileURL) else { return }
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
//                } else {
//                    UIApplication.shared.openURL(URL)
//                }
//            }
//
//        }).disposed(by: reviewsView.disposeBag)
        
        
        reviewsView.reviewsTableView.rx.itemSelected.subscribe { [unowned self] indexPath in
            // expand cell according to indexPath
            self.selectedIndex = indexPath
            self.reviewsView.reviewsTableView.beginUpdates()
            self.reviewsView.reviewsTableView.reloadRows(at: [self.selectedIndex], with: .none)
            self.reviewsView.reviewsTableView.endUpdates()
        }.disposed(by: reviewsView.disposeBag)
        
        // set tableview delegate for row height
        
        reviewsView.reviewsTableView.rx.setDelegate(self).disposed(by: reviewsView.disposeBag)
        
    }


    
}

//MARK: - TableView Delegate Rowheight

extension ReviewsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath { return tableView.frame.size.height * 0.5}
        return tableView.frame.size.height * 0.20
    }
    
    
}
