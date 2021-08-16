//
//  Restaurant.swift
//  Delivery
//
//  Created by Øyvind Hauge on 21/01/2021.
//

import Foundation

struct Restaurant: Codable {
    
    private enum CodingKeys: CodingKey {
        case id, name, position, menu
    }
    
    var id: Int
    var name: String
    var position: Coordinates
    var menu: [Food]
}
