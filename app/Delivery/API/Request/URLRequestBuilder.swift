//
//  URLRequestBuilder.swift
//  Delivery
//
//  Created by Øyvind Hauge on 27/04/2021.
//

import Foundation

final class URLRequestBuilder {
    
    var baseURL: URL = URL(string: "http://localhost:8084")!
    var endpoint: String
    var method: HTTPMethod = .get
    var headers: [String: String]?
    var accessToken: String?
    var params: [DEParam]?
    var body: Data?
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    @discardableResult
    func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    @discardableResult
    func set(endpoint: String) -> Self {
        self.endpoint = endpoint
        return self
    }
    
    @discardableResult
    func set(headers: [String: String]?) -> Self {
        self.headers = headers
        return self
    }
    
    @discardableResult
    func set(params: [DEParam]?) -> Self {
        self.params = params
        return self
    }
    
    @discardableResult
    func set(accessToken: String?) -> Self {
        self.accessToken = accessToken
        return self
    }
    
    @discardableResult
    func set(body: Data?) -> Self {
        self.body = body
        return self
    }
    
    func build() -> URLRequest {
        
        // create url and add query parameters
        var url = baseURL.appendingPathComponent(endpoint)
        if let params = params, !params.isEmpty, var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var queryItems: [URLQueryItem] = []
            for param in params {
                queryItems.append(URLQueryItem(name: param.name, value: param.value))
            }
            comps.queryItems = queryItems
            if let newUrl = comps.url {
                url = newUrl
            }
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        // request method
        request.httpMethod = method.rawValue
        
        // add headers
        addHeaders(&request)
        
        // request body
        if let jsonData = body {
            request.httpBody = jsonData
        }
        return request
    }
    
    private func addHeaders(_ request: inout URLRequest) {
        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
    }
    
    private func defaultHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
}

extension URLRequestBuilder {
    
    static func buildOpenAPIRequest<T: DERequest>(for request: T) -> URLRequest {
        return URLRequestBuilder(endpoint: request.endpoint)
            .set(headers: ["Content-Type": "application/json"])
            .set(method: request.method)
            .set(params: request.params)
            .set(body: request.body)
            .build()
    }
    
    func decode<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
