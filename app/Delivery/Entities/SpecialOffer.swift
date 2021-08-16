//
//  SpecialOffer.swift
//  Delivery
//
//  Created by Øyvind Hauge on 23/03/2021.
//

import Foundation

struct SpecialOffer: Codable {
    
    private enum CodingKeys: CodingKey {
        case id, customerID, price
        case food
    }
    
    var id, customerID, price: Int
    var food: Food
    var expirationTime: String?
}
