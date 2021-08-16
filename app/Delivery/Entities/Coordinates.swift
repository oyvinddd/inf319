//
//  Coordinates.swift
//  Delivery
//
//  Created by Øyvind Hauge on 07/02/2021.
//

import Foundation

struct Coordinates: Codable {
    var lat, lng: Float
    
    init(_ lat: Float, _ lng: Float) {
        self.lat = lat
        self.lng = lng
    }
}
