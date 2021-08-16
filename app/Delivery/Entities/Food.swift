//
//  Food.swift
//  Delivery
//
//  Created by Øyvind Hauge on 07/02/2021.
//

import UIKit

struct Food: Codable {
    
    private static let emojisAndColors: [(String, UIColor)] = [
        ("🍔", UIColor.Food.burger),
        ("🍣", UIColor.Food.sushi),
        ("🍝", UIColor.Food.pasta),
        ("🐠", UIColor.Food.fish),
        ("🥩", UIColor.Food.steak),
        ("🍕", UIColor.Food.pizza),
        ("🥗", UIColor.Food.salad),
        ("🐔", UIColor.Food.chicken),
        ("🦑", UIColor.Food.squid),
        ("🍜", UIColor.Food.ramen),
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
