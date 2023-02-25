//
//  CustomAnnotationView.swift
//  Hity
//
//  Created by Ekrem Alkan on 19.02.2023.
//

import UIKit
import MapKit

final class CustomAnnotationView: MKAnnotationView {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override var image: UIImage? {
        get {
            return self.imageView.image
        }
        
        set {
            self.imageView.image = newValue
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addSubview()
        setupConstraints()
    }
}


//MARK: - AddSubview / Constraints

extension CustomAnnotationView {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        self.addSubview(imageView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        imageViewConstraints()
    }
    
    private func imageViewConstraints() {
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.top.leading.equalTo(self).offset(3)
            make.bottom.trailing.equalTo(self).offset(-3)
        }
    }
    
    
    
}

