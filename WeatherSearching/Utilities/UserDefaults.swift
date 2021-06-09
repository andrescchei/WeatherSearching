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
    
    var searches: [WeatherModel] {
        set(newValue) {
            UserDefaults.standard.setStructArray(newValue, forKey: "searches")
        }
        get {
            return UserDefaults.standard.structArrayData(WeatherModel.self, forKey: "searches")
        }
    }
    
    func addSearch(_ model: WeatherModel) -> [WeatherModel] {
        print((model.name,model.id))
        print(searches.map { ($0.name, $0.id) })
        let _searches = searches.filter {
            model.name != $0.name && !(model.name?.isEmpty ?? true)
        }
        searches = [model] + _searches
        return searches
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
