//
//  UserDefaults.swift
//  WeatherSearching
//
//  Created by Andres Chan on 8/6/2021.
//

import Foundation
import Combine

class UserDefaultsManager: ObservableObject {
    
    static let shared = UserDefaultsManager()
    
    @Published var searches: [WeatherModel] {
        didSet {
            UserDefaults.standard.setStructArray(searches, forKey: "searches")
        }
    }
    
    init() {
        searches = UserDefaults.standard.structArrayData(WeatherModel.self, forKey: "searches")        
    }
    
    func addSearch(_ model: WeatherModel) {
        searches = [model] + searches
    }
    
   
}

extension UserDefaults {
    func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String) {
        let data = value.map { try? JSONEncoder().encode($0) }

        set(data, forKey: defaultName)
    }

    func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T: Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }

        return encodedData.compactMap {
            let result = try? JSONDecoder().decode(type, from: $0)
            return result
        }
    }
}
