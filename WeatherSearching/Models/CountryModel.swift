//
//  CountryModel.swift
//  WeatherSearching
//
//  Created by Andres Chan on 6/6/2021.
//

import Foundation

struct CountryModel: Codable, Hashable {
    let name: String
    let alpha_2: String
    let country_code: String
    
    public static func == (lhs: CountryModel, rhs: CountryModel) -> Bool {
        return lhs.alpha_2 == rhs.alpha_2 &&
            lhs.country_code == rhs.country_code &&
            lhs.name == rhs.name
    }
}
