//
//  UIImageView+DownloadImage.swift
//  Hity
//
//  Created by Ekrem Alkan on 4.02.2023.
//

import UIKit

extension UIImageView {
    
    func downloadSetImage(url: String) {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(url)&key=\(ApiKey.API_KEY.rawValue)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            task.resume()
        }
}
