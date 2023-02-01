//
//  OnboardingController.swift
//  Hity
//
//  Created by Ekrem Alkan on 31.01.2023.
//

import UIKit

final class OnboardingController: UIViewController {

    //MARK: - Properties

    private let onboardingView = OnboardingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - ConfigureViewController

    private func configureViewController() {
        view = onboardingView
        onboardingView.interface = self
    }

}

//MARK: - OnboardingViewInterface

extension OnboardingController: OnboardingInterface {
    func onboardingView(_ view: OnboardingView, buttonTapped button: UIButton) {
        let controller = SearchController()
        show(controller, sender: nil)
    }
    
    
}
