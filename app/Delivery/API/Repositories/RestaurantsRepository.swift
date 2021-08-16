//
//  RestaurantsRepository.swift
//  Delivery
//
//  Created by Øyvind Hauge on 27/04/2021.
//

import Foundation

final class RestaurantsRepository: RestaurantsAPI {
    let session = URLSession.shared
    
    func getRestaurants(result: @escaping ResultBlock<[Restaurant]>) {
        let request = URLRequestBuilder.buildOpenAPIRequest(for: RestaurantsRequest())
        session.dataTask(with: request, decodable: [Restaurant].self, result: result).resume()
    }
}
