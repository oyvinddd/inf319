//
//  DERequest.swift
//  Delivery
//
//  Created by Øyvind Hauge on 27/04/2021.
//

import Foundation

struct Endpoints {
    
    static let apiVersion = "/api/v1"
    
    static let restaurants = "\(apiVersion)/restaurants"
    
    static let orders = "\(apiVersion)/orders"
}

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct DEParam {
    var name: String
    var value: String
    init(_ name: String, _ value: String) {
        self.name = name
        self.value = value
    }
}

protocol DERequest {
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var params: [DEParam] { get }
    var body: Data? { get }
}

struct RestaurantsRequest: DERequest {
    var endpoint: String = Endpoints.restaurants
    var method: HTTPMethod = .get
    var params: [DEParam] = []
    var body: Data? = nil
}

struct CreateOrderRequest: DERequest {
    var endpoint: String = Endpoints.orders
    var method: HTTPMethod = .post
    var params: [DEParam] = []
    var body: Data?
    
    init(_ request: OrderRequest) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        body = try? encoder.encode(request)
    }
}

struct OrdersRequest: DERequest {
    var endpoint: String = Endpoints.orders
    var method: HTTPMethod = .get
    var params: [DEParam] = []
    var body: Data? = nil
}
