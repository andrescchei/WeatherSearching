//
//  SearchingVM.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//

import Foundation
import Combine
import Alamofire
import CoreLocation

enum SearchBy: CaseIterable {
    case name, zipcode, location
    
    func getDisplayName() -> String {
        switch self {
        case .name:
            return "City name"
        case .zipcode:
            return "Zip code"
        case .location:
            return "Location"
        }
    }
}

final class SearchingVM: ObservableObject {
    // input
    @Published var searchBy: SearchBy = .zipcode
    @Published var name = ""
    @Published var zipcode = ""
    @Published var lon = ""
    @Published var lat = ""
    @Published var selectedCountry: String = ""
  
    // output
    @Published var result: Result<WeatherModel, AFError>? = nil
    
    var bag = Set<AnyCancellable>()
    
    init() {

        let zipCodePub = Publishers.CombineLatest(
            $zipcode.removeDuplicates(),
            $selectedCountry.removeDuplicates())
        
        let locationPub = Publishers.CombineLatest(
            $lon.removeDuplicates(),
            $lat.removeDuplicates())
        
        Publishers.CombineLatest3(
            $name.removeDuplicates(),
            zipCodePub,
            locationPub)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .print()
            .map { [weak self] (name, zipPair, locationPair) -> Any? in
                guard let self = self else { return nil }
                switch self.searchBy {
                case .name:
                    return name
                case .zipcode:
                    return zipPair
                case .location:
                    return locationPair
                }
            }
            .filter { any in
                if let anyString = any as? String {
                    return !anyString.isEmpty
                } else if let (zip, country) = any as? (String, String) {
                    return !zip.isEmpty && !country.isEmpty
                } else if let (lon, lat) = any as? (String, String) {
                    return !lon.isEmpty && !lat.isEmpty
                } else {
                    return false
                }
            }
            .flatMap { [weak self] any -> AnyPublisher<Result<WeatherModel, AFError>, Never> in
                guard let self = self,
                      let safeAny = any
                    else { return Empty().eraseToAnyPublisher() }
                switch self.searchBy {
                case .name:
                    guard let name: String = safeAny as? String else { return Empty().eraseToAnyPublisher() }
                    return NetworkManager.shared.getWeatherByCityName(name: name)
                case .zipcode:
                    print("zipcode: \(safeAny)")
                    guard let (zipcode, country) = safeAny as? (String, String)
                          else { return Empty().eraseToAnyPublisher() }
                    return NetworkManager.shared.getWeatherByZipcode(code: zipcode, country: country)
                case .location:
                    guard let (lon, lat) = safeAny as? (String, String) else { return Empty().eraseToAnyPublisher() }
                    return NetworkManager.shared.getWeatherByGPS(lon: lon, lat: lat)
                }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print("Finished?")
                    break
                }
            }) { [weak self] result in
                print("getWeather result \(result)")
                self?.result = result
            }
            .store(in: &bag)
    }

}
