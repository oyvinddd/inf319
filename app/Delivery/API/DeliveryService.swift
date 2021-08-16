//
//  DeliveryService.swift
//  Delivery
//
//  Created by Øyvind Hauge on 27/04/2021.
//

import Foundation

final class DeliveryService {
    
    private static let restaurantsRepo = RestaurantsRepository()
    private static let ordersRepo = OrdersRepository()
    
    struct Restaurants {
        
        static func list(result: @escaping ResultBlock<[Restaurant]>) {
            restaurantsRepo.getRestaurants(result: result)
        }
    }
    
    struct Orders {
        
        static func create(request: OrderRequest, result: @escaping ResultBlock<Order>) {
            ordersRepo.createOrder(orderRequest: request, result: result)
        }
        
        static func list(result: @escaping ResultBlock<[Order]>) {
            ordersRepo.getOrders(customerID: 0, result: result)
        }
    }
}
