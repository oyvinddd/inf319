//
//  Account.swift
//  Delivery
//
//  Created by Øyvind Hauge on 23/01/2021.
//

import UIKit

struct Account {
    var id: Int
    var email: String
    var firstName: String?
    var lastName: String?
    var picture: UIImage?
}

extension Account {
    static let current = Account(id: 2, email: "user@test.com", firstName: "Øyvind")
}
