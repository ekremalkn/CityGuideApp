//
//  UIView+Shadow.swift
//  Hity
//
//  Created by Ekrem Alkan on 13.02.2023.
//

import UIKit


extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.masksToBounds = false
    }
    
}
