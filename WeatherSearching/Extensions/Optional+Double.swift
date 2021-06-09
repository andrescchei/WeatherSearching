//
//  Optional+Double.swift
//  WeatherSearching
//
//  Created by Andres Chan on 10/6/2021.
//

import Foundation

extension Optional where Wrapped == Double {
    func toString() -> String {
        guard let safe = self else { return "" }
        return "\(safe)"
    }
}
