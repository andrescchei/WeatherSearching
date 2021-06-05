//
//  NetworkManager.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private func call<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        request.httpMethod
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher
    }
}
