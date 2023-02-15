//
//  SearchView.swift
//  Hity
//
//  Created by Ekrem Alkan on 29.01.2023.
//

import UIKit
import MapKit
import SnapKit



final class SearchView: UIView {
    
    //MARK: - Creating UI Elements

    let mapView = MKMapView()
    
    //MARK: - Creating Nav Bar Items
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.dash"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var distanceSlider: UISlider = {
        let slider = UISlider()
        slider.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
        slider.minimumValue = 0.05
        slider.maximumValue = 100
        slider.value = 50
        slider.minimumValueImage = UIImage(systemName: "minus")
        slider.maximumValueImage = UIImage(systemName: "plus")
        return slider
    }()
    
    
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
        backgroundColor = .blue
        addSubview()
        setupConstraints()
    }

}

//MARK: - UI Elements Addsubview / Constraints

extension SearchView {
    //MARK: - AddSubview
    
    private func addSubview() {
        addSubview(mapView)
        addSliderToMapView()
    }
    
    private func addSliderToMapView() {
        mapView.addSubview(distanceSlider)
    }
   
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        mapViewConstraints()
        distanceSliderConstraints()
    }
    
    private func mapViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func distanceSliderConstraints() {
        distanceSlider.snp.makeConstraints { make in
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
            make.bottom.equalTo(mapView.snp.centerY).offset(-50)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(50)
        }
    }


}
