//
//  SortPopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 23.02.2023.
//

import UIKit
import RxSwift

enum SortTypesTitle: String, CaseIterable {
    case logic = "Most relevant"
    case maxToMinRating = "Ratings"
    case userRatingTotal = "User ratings total"
    
}

enum SortTypesSubTitle: String, CaseIterable {
    case logic = "See the most relevant places"
    case maxToMinRating = "See all places, starting with the heighest rating"
    case userRatingTotal = "See all places, starting with the heighest user rating total"
    
}

final class SortPopUpController: UIViewController {
    
    deinit {
        print("SortPopUp deinit oldu le")
    }
    
    //MARK: - Constants
    
    private let sortPopUpView = SortPopUpView()
    
    //MARK: - Observable Variables
    
    let sortTypesTitle = PublishSubject<SortTypesTitle.AllCases>()
    let tableViewCellSelected = PublishSubject<SortTypesTitle>()
    
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
        sortTypesTitle.onNext(SortTypesTitle.allCases)
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        tapGestureCallbacks()
        createTableViewCallbacks()
    }
    
    //MARK: - AddGestureRecocgnizer to View
    
    private func addGestureRecognizerToView() {
        sortPopUpView.emptyView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - TapGesture Callbacks
    
    private func tapGestureCallbacks() {
        tapGesture.rx.event.subscribe { [weak self] recognizer in
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
    }
    
    //MARK: - TableView Callbacks
    
    private func createTableViewCallbacks() {
        
        // bind Sort TypesTitle to tableview
        sortTypesTitle.bind(to: sortPopUpView.tableView.rx.items(cellIdentifier: SortPopUpCell.identifier, cellType: SortPopUpCell.self)) { row, sortTypeTitle , cell in
            let textLabel = sortTypeTitle.rawValue
            let detailTextLabel = SortTypesSubTitle.allCases[row].rawValue
            cell.changeText(textLabel, detailTextLabel)
        }.disposed(by: disposeBag)
        
        //handle did select
        
        sortPopUpView.tableView.rx.modelSelected(SortTypesTitle.self).bind { [weak self] sortTypeTitle in
            self?.tableViewCellSelected.onNext(sortTypeTitle)
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
        
        sortPopUpView.tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let cell = self?.sortPopUpView.tableView.cellForRow(at: indexPath) as? SortPopUpCell else { return }
            cell.toggleImageView(true)
        }).disposed(by: disposeBag)
        
        // handle deselect
        
        sortPopUpView.tableView.rx.itemDeselected.subscribe(onNext: { [weak self] indexPath in
            guard let cell = self?.sortPopUpView.tableView.cellForRow(at: indexPath) as? SortPopUpCell else { return }
            cell.toggleImageView(false)
        }).disposed(by: disposeBag)
        
        
    }
    
    
}

//MARK: - SortPopUpView Configure

extension SortPopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        //        self.sortPopUpView.backgroundColor = .black.withAlphaComponent(0.6)
        self.sortPopUpView.alpha = 0
        self.sortPopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            self?.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
            self.sortPopUpView.alpha = 1
            self.sortPopUpView.contentView.alpha = 1
            self.sortPopUpView.frame = CGRect(x: 0 , y: -Int(self.view.frame.height) / 2, width: Int(self.view.frame.width), height: Int(self.view.frame.height) / 2)
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [unowned self] in
            self.sortPopUpView.frame.origin.y = self.sortPopUpView.frame.height
            
            self.sortPopUpView.alpha = 0
            self.sortPopUpView.contentView.alpha = 0
            
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
        }
        
    }
}

//MARK: - View AddSubview / Constraints

extension SortPopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(sortPopUpView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        sortPopUpView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
    
}
