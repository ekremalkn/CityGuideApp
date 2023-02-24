//
//  ReviewsController.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit
import RxSwift

final class ReviewsController: UIViewController {

    
    //MARK: - Properties
    
    private let reviewsView = ReviewsView()
    private let reviewsViewModel = ReviewsViewModel()
    private let disposeBag = DisposeBag()
    
    var placeUID: String

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
        createTableViewCallbacks()
    }
    
    private func customizeNavBar() {
        title = "Reviews"
        navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reviewsView)
    }
    
    //MARK: - TableView Callbacks
    
    private func createTableViewCallbacks() {
        
        //bind placereviews to tableview
        reviewsViewModel.placeReviews.bind(to: reviewsView.reviewsTableView.rx.items(cellIdentifier: ReviewsCell.identifier, cellType: ReviewsCell.self)) { row, placeReviews, cell in
            cell.configure(placeReviews)
            
        }.disposed(by: disposeBag)
        
        
        //fetch placereviews
        
        self.reviewsViewModel.fetchPlaceReviews(placeUID)
        
        //handle did select
        
        reviewsView.reviewsTableView.rx.modelSelected(DetailReview.self).bind(onNext: { placeReviews in
            if let authorProfileURL = placeReviews.authorURL {
                guard let URL = URL(string: authorProfileURL) else { return }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL)
                }
            }
            
            

            
        }).disposed(by: disposeBag)
        
        // set tableview delegate for row height
        
        reviewsView.reviewsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }


    
}

//MARK: - TableView Delegate Rowheight

extension ReviewsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height * 0.33
    }
}
