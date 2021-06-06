//
//  ResourcesManager.swift
//  WeatherSearching
//
//  Created by Andres Chan on 6/6/2021.
//

import Foundation

final class ResourcesManager {
    static let shared = ResourcesManager()
    
    let countryList: [CountryModel]
    
    init() {
        guard let countryListPath = Bundle.main.path(forResource: "countryCodeList", ofType: "json"),
            let countryListData = FileManager.default.contents(atPath: countryListPath) else
        {
            countryList = []
            return
        }
        
        countryList = (try? JSONDecoder().decode([CountryModel].self, from: countryListData)) ?? []
        
    }
}
