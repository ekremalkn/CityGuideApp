//
//  PlaceDetailController.swift
//  Hity
//
//  Created by Ekrem Alkan on 5.02.2023.
//

import UIKit

final class PlaceDetailController: UIViewController {
    
    //MARK: - Properties
    
    private let placeDetailView = PlaceDetailView()
    var place: DetailResults

    //MARK: - Init Methods
    
    init(place: DetailResults) {
        self.place = place
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
        view = placeDetailView
        placeDetailView.configure(data: place)
    }
    
    


}
