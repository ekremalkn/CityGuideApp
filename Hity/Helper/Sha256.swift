//
//  Sha256.swift
//  Hity
//
//  Created by Ekrem Alkan on 10.02.2023.
//

import Foundation
import CryptoKit

final class Sha256 {
    
    static let shared = Sha256()
    
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
}
