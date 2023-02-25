//
//  ContainerController.swift
//  Hity
//
//  Created by Ekrem Alkan on 22.02.2023.
//

import UIKit
import RxSwift

final class ContainerController: UIViewController {
    
    enum MenuPosition {
        case opened
        case closed
    }
    
    private var menuPosition: MenuPosition = .closed
    
    //MARK: - Child ViewControllers
    
    var searchController = SearchController()
    var profileController = ProfileController()
    var navigationVController: UINavigationController?
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let tapGesture = UITapGestureRecognizer()
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        createCallbacks()
    }
    
    //MARK: - AddChild ViewControllers
    
    private func addChildViewControllers() {
        
        // Add profile vc
        addChild(profileController)
        view.addSubview(profileController.view)
        profileController.didMove(toParent: self)
        
        // add search vc
        let navigationController = UINavigationController(rootViewController: searchController)
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        self.navigationVController = navigationController
        
    }
    
    //MARK: - Create Callbacks

    private func createCallbacks() {
        tapGestureCallback()
        createSearchControllerLeftButtonCallback()
    }
    
    //MARK: - Tap Gesture Callback

    private func tapGestureCallback() {
        tapGesture.rx.event.bind { recognizer in
            self.hideMenu()
        }.disposed(by: disposeBag)
    }
    
    
    //MARK: - Creating SearchController Nav left button callback
    
    private func createSearchControllerLeftButtonCallback() {
        searchController.searchView.leftButton.rx.tap.bind(onNext: { [unowned self] in
            switch self.menuPosition {
            case .opened:
                self.searchController.view.removeGestureRecognizer(tapGesture)
                self.hideMenu()
            case .closed:
                self.searchController.view.addGestureRecognizer(tapGesture)
                self.showMenu()
                
            }
        }).disposed(by: searchController.disposeBag)
    }
    
    //MARK: - Menu Toggle

    private func showMenu() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.navigationVController?.view.frame.origin.x = self.searchController.view.frame.size.width - (self.searchController.view.frame.size.width * 0.22)    } completion: { [weak self] isOpened in
                if isOpened {
                    self?.menuPosition = .opened
                }
            }
    }
    
    private func hideMenu() {
        self.searchController.userDataViewModel.fetchProfilePhoto()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.navigationVController?.view.frame.origin.x = 0
            
        } completion: { [weak self] isOpened in
            if isOpened {
                self?.menuPosition = .closed
            }
        }
    }
    
}
