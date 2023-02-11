//
//  Encodable+Dictionary.swift
//  Hity
//
//  Created by Ekrem Alkan on 11.02.2023.
//

import Foundation


struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    
    var dictionary: [String: Any] {
        let data = (try? JSON.encoder.encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
