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
    
    let navBarLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        button.setTitle("Tap your Location", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    var rightImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.tintColor = .black
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "123123123"
        label.textColor = .black
        return label
    }()
 
    //MARK: - Layout Subview
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    
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
        addSubview(label)
    }
  
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        mapViewConstraints()
        rightImageViewConstraints()
    }
    
    private func mapViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func rightImageViewConstraints() {
        rightImageView.snp.makeConstraints { make in
            make.width.equalTo(rightImageView.snp.height)
        }
    }
   


}
