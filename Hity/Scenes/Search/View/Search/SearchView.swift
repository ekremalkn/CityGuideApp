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
    }
    
    private func mapViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }


}
