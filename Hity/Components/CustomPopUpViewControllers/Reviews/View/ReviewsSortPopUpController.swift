//
//  ReviewsSortPopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 26.02.2023.
//

import UIKit
import RxSwift

enum ReviewsSortTypesTitle: String, CaseIterable {
    case logic = "Most relevant"
    case maxToMinRating = "Highest Ratings"
    case newestToOldest = "Newest"
}

enum ReviewsSortTypesSubTitle: String, CaseIterable {
    case logic = "See the most relevant comments"
    case maxToMinRating = "See all comments, starting with the highest"
    case newestToOldest = "See all comments, starting with the newest"
}

final class ReviewsSortPopUpController: UIViewController {
    
    //MARK: - Constants
    
    private let reviewsSortPopUpView = ReviewsSortPopUpView()
    
    //MARK: - Observable Variables
    
    let sortTypesTitle = PublishSubject<ReviewsSortTypesTitle.AllCases>()
    let tableViewCellSelected = PublishSubject<ReviewsSortTypesTitle>()
    
    //MARK: - Dispose Bag
    
    let disposeBag = DisposeBag()
    
    //MARK: - Tap Gesture
    
    let tapGesture = UITapGestureRecognizer()
    
    //MARK: - Init Methods
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        addSubview()
        setupConstraints()
        appearanceWhenViewDidLoad()
        addGestureRecognizerToView()
        createCallbacks()
        sortTypesTitle.onNext(ReviewsSortTypesTitle.allCases)
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        tapGestureCallbacks()
        createTableViewCallbacks()
    }
    
    //MARK: - AddGestureRecognizer to View
    
    private func addGestureRecognizerToView() {
        reviewsSortPopUpView.emptyView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - TapGesture Callbacks
    
    private func tapGestureCallbacks() {
        tapGesture.rx.event.subscribe { [weak self] recognizer in
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
    }
    
    //MARK: - TableView Callback

    private func createTableViewCallbacks() {
        
        // bind Reviews SortTypesTitle to Tableview
        sortTypesTitle.bind(to: reviewsSortPopUpView.tableView.rx.items(cellIdentifier: SortPopUpCell.identifier, cellType: SortPopUpCell.self)) { row, sortTypeTitle, cell in
            let textLabel = sortTypeTitle.rawValue
            let detailTextLabel = ReviewsSortTypesSubTitle.allCases[row].rawValue
            cell.changeText(textLabel, detailTextLabel)
            
        }.disposed(by: disposeBag)
        
        // handle did select
        reviewsSortPopUpView.tableView.rx.modelSelected(ReviewsSortTypesTitle.self).bind { [weak self] sortTypeTitle in
            self?.tableViewCellSelected.onNext(sortTypeTitle)
            self?.hidePopUpView()
        }.disposed(by: reviewsSortPopUpView.disposeBag)
        
        reviewsSortPopUpView.tableView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let cell = self?.reviewsSortPopUpView.tableView.cellForRow(at: indexPath) as? SortPopUpCell else { return }
            cell.toggleImageView(true)
        }.disposed(by: reviewsSortPopUpView.disposeBag)
        
        //handle deselect
        reviewsSortPopUpView.tableView.rx.itemDeselected.subscribe { [weak self] indexPath in
            guard let cell = self?.reviewsSortPopUpView.tableView.cellForRow(at: indexPath) as? SortPopUpCell else { return }
            cell.toggleImageView(false)
        }.disposed(by: reviewsSortPopUpView.disposeBag)
    }
    
}

//MARK: - ReviewsSortPopUpView Configure

extension ReviewsSortPopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        reviewsSortPopUpView.alpha = 0
        reviewsSortPopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            self?.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
            self.reviewsSortPopUpView.alpha = 1
            self.reviewsSortPopUpView.contentView.alpha = 1
            self.reviewsSortPopUpView.frame = CGRect(x: 0 , y: -Int(self.view.frame.height) / 2, width: Int(self.view.frame.width), height: Int(self.view.frame.height) / 2)
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [unowned self] in
            self.reviewsSortPopUpView.frame.origin.y = self.reviewsSortPopUpView.frame.height
            self.reviewsSortPopUpView.alpha = 0
            self.reviewsSortPopUpView.contentView.alpha = 0
        } completion: {  [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
        }

    }
}

//MARK: - View AddSubview / Constraints

extension ReviewsSortPopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(reviewsSortPopUpView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        reviewsSortPopUpView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }


}


