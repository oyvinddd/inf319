//
//  Food.swift
//  Delivery
//
//  Created by Γyvind Hauge on 07/02/2021.
//

import UIKit

struct Food: Codable {
    
    private static let emojisAndColors: [(String, UIColor)] = [
        ("π", UIColor.Food.burger),
        ("π£", UIColor.Food.sushi),
        ("π", UIColor.Food.pasta),
        ("π ", UIColor.Food.fish),
        ("π₯©", UIColor.Food.steak),
        ("π", UIColor.Food.pizza),
        ("π₯", UIColor.Food.salad),
        ("π", UIColor.Food.chicken),
        ("π¦", UIColor.Food.squid),
        ("π", UIColor.Food.ramen),
    ]
    
    var restaurantId: Int
    var type: Int
    var name: String
    var lowerPrice: Float
    var normalPrice: Float
    var preparationTime: Int
    var expirationTime: Int
    
    func emojiAndColor() -> (String, UIColor) {
        if type >= 0 && type <= 9 {
            let emoji = Food.emojisAndColors[type].0
            let backgroundColor = Food.emojisAndColors[type].1
            return (emoji, backgroundColor)
        }
        return Food.emojisAndColors[0]
    }
}
