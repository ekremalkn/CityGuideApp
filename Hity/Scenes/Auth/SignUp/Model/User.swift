//
//  User.swift
//  Hity
//
//  Created by Ekrem Alkan on 11.02.2023.
//

import Foundation

struct User: Codable {
    var id: String?
    var username: String?
    var email: String?
    var favorite: [String : Int]?
}
