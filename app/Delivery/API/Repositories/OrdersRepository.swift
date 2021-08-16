//
//  OrdersRepository.swift
//  Delivery
//
//  Created by Øyvind Hauge on 29/04/2021.
//

import Foundation

final class OrdersRepository: OrdersAPI {
    let session = URLSession.shared
    
    func createOrder(orderRequest: OrderRequest, result: @escaping ResultBlock<Order>) {
        let request = URLRequestBuilder.buildOpenAPIRequest(for: CreateOrderRequest(orderRequest))
        session.dataTask(with: request, decodable: Order.self, result: result).resume()
    }
    
    func getOrders(customerID: Int, result: @escaping ResultBlock<[Order]>) {
        let request = URLRequestBuilder.buildOpenAPIRequest(for: OrdersRequest())
        session.dataTask(with: request, decodable: [Order].self, result: result).resume()
    }
}
