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
    
    var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .black
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.layer.masksToBounds = true
        return imageView
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
