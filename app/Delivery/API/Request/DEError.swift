//
//  DEError.swift
//  Delivery
//
//  Created by Øyvind Hauge on 27/04/2021.
//

import Foundation

public struct DEError: Error, Decodable {
    
    public static let unknown = DEError("Unknown error", status: 900)
    public static let decodingFailed = DEError("Decoding failed", status: 901)
    
    enum CodingKeys: String, CodingKey {
        case message, status, error
    }
    var message: String
    var status: Int
    var error: String?
    public var errorDescription: String? {
        return "\(status) - \(message)"
    }
    
    init(_ message: String, status: Int, error: String? = nil) {
        self.message = message
        self.status = status
        self.error = error
    }
}
