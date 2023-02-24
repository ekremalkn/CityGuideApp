//
//  DistancePopUpController.swift
//  Hity
//
//  Created by Ekrem Alkan on 24.02.2023.
//

import UIKit
import RxSwift

final class DistancePopUpController: UIViewController {
    
    deinit {
        print("Deinit distance popup")
    }
    
    //MARK: - Properties
    
    private let distancePopUpView = DistancePopUpView()

    private let disposeBag = DisposeBag()
    let tapGesture = UITapGestureRecognizer()
    
    // observable

    var whenTapSetButtonDistance = PublishSubject<String>()
    var whenChangeSliderValueDistance: String?
    
    //MARK: - Init Methods
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        addSubview()
        setupConstraints()
        self.distancePopUpView.emptyView.addGestureRecognizer(tapGesture)
        tapGestureCallbacks()
        createDistancePopUpButtonViewCallbacks()
        createDistanceSliderCallbacks()
    }

    
    private func tapGestureCallbacks() {
        tapGesture.rx.event.subscribe { [weak self] recognizer in
            self?.hidePopUpView()
        }.disposed(by: disposeBag)
    }
    
    //MARK: - DistancePopUpView UI Elements  callbacks
    
    private func createDistancePopUpButtonViewCallbacks() {
        distancePopUpView.setButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.whenTapSetButtonDistance.onNext(self?.whenChangeSliderValueDistance ?? "1000")
            self?.hidePopUpView()
        }).disposed(by: disposeBag)
        
        
    }
    
    private func createDistanceSliderCallbacks() {
        distancePopUpView.distanceSlider.rx.value.subscribe { [weak self] slider in
            switch slider {
                
            case .next(let value):
                let roundedValue = Int(round(value)) * 100
                self?.whenChangeSliderValueDistance = "\(roundedValue)"
                self?.distancePopUpView.distanceLabel.text = "\(roundedValue)m"

            default:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    



}

//MARK: - DistancePopUpView Configure

extension DistancePopUpController {
    
    private func appearanceWhenViewDidLoad() {
        self.view.backgroundColor = .clear
        self.distancePopUpView.alpha = 0
        self.distancePopUpView.contentView.alpha = 0
    }
    
    func presentPopUpController(_ sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            self?.showPopUpView()
        }
    }
    
    private func showPopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
            self.distancePopUpView.alpha = 1
            self.distancePopUpView.contentView.alpha = 1
            self.distancePopUpView.frame = CGRect(x: 0 , y: -Int(self.view.frame.height) / 2, width: Int(self.view.frame.width), height: Int(self.view.frame.height) / 2)
        }
    }
    
    private func hidePopUpView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [unowned self] in
            self.distancePopUpView.frame.origin.y = self.distancePopUpView.frame.height
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
            self?.removeFromParent()
        }

    }
}


//MARK: - View AddSubview / Constraints

extension DistancePopUpController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(distancePopUpView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        distancePopUpView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(view)
        }
    }


}
