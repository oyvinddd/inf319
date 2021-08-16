//
//  DeliveryAPI.swift
//  Delivery
//
//  Created by Øyvind Hauge on 27/04/2021.
//

import Foundation

enum EntityResult<T: Codable> {
    case success(T)
    case failure(Error)
}

typealias ResultBlock<T: Codable> = (EntityResult<T>) -> Void

// MARK: - Restaurants API

protocol RestaurantsAPI {
    func getRestaurants(result: @escaping ResultBlock<[Restaurant]>)
}

// MARK: - Orders API

protocol OrdersAPI {
    func createOrder(orderRequest: OrderRequest, result: @escaping ResultBlock<Order>)
}
