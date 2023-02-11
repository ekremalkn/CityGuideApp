//
//  UITextField+RightViewButton.swift
//  Hity
//
//  Created by Ekrem Alkan on 12.02.2023.
//

import UIKit

extension UITextField {
    
    func setRightVewButton( _ button: UIButton, _ imageName: String) {
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        self.rightView = button
        self.rightViewMode = .always
    }
}
