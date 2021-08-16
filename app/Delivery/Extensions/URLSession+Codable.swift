//
//  URLSession+Codable.swift
//  Delivery
//
//  Created by Øyvind Hauge on 27/04/2021.
//

import Foundation

extension URLSession {
    func dataTask<T: Decodable>(with request: URLRequest, decodable: T.Type, result: @escaping ResultBlock<T>) -> URLSessionDataTask {
        return dataTask(with: loggedRequest(request)) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    result(.failure(error))
                    return
                }
                guard let urlResponse = response as? HTTPURLResponse, let data = data else {
                    result(.failure(DEError.unknown))
                    return
                }
                guard 200 ..< 300 ~= urlResponse.statusCode else {
                    print("Delivery - Status code was \(urlResponse.statusCode), but expected 2xx")
                    do {
                        let error: DEError = try self.decode(from: data)
                        result(.failure(error))
                    } catch {
                        result(.failure(DEError.unknown))
                    }
                    return
                }
                do {
                    let entity: T = try self.decode(from: data)
                    result(.success(entity))
                } catch {
                    result(.failure(DEError.decodingFailed))
                }
            }
        }
    }
    
    private func decode<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
    private func loggedRequest(_ request: URLRequest) -> URLRequest {
        if let url = request.url, let method = request.httpMethod {
            var headersString = ""
            if let headers = request.allHTTPHeaderFields {
                for header in headers {
                    headersString += "[\(header.key): \(header.value)]"
                }
            }
            print("[👾][\(method)][\(url.absoluteString)]\(headersString)")
        }
        return request
    }
}
