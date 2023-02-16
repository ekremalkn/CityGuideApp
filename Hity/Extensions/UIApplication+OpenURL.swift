//
//  UIApplication+OpenURL.swift
//  Hity
//
//  Created by Ekrem Alkan on 16.02.2023.
//

import UIKit

extension UIApplication {
    
    func openURLDefaultScanner(_ url: String?) {
        guard let url = url else { return }
        guard let URL = URL(string: url) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL)
        }
    }
}
