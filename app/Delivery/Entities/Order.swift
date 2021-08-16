//
//  Order.swift
//  Delivery
//
//  Created by Øyvind Hauge on 29/04/2021.
//

import Foundation

struct Order: Codable {
    var id: Int
    var status: Int
    var food: Food
    var origin: Restaurant
}

struct OrderRequest: Codable {
    var customerId: Int
    var food: Food
}
