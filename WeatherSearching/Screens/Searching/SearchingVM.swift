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
    @Published var searchBy: SearchBy = .name
    @Published var name = UserDefaultsManager.shared.searches.first?.name ?? ""
    @Published var zipcode = ""
    @Published var lon = ""
    @Published var lat = ""
    @Published var selectedCountry: String = ResourcesManager.shared.countryList.first?.alpha_2 ?? ""
  
    // output
    @Published var result: Result<WeatherModel, AFError>? = nil
    @Published var weatherModel: WeatherModel? = nil
    @Published var errorMessage: String? = nil
    @Published var searches = UserDefaultsManager.shared.searches {
        didSet {
            UserDefaultsManager.shared.searches = searches
        }
    }
    
    var bag = Set<AnyCancellable>()
    
    init() {

        let zipCodePub = Publishers.CombineLatest(
            $zipcode.removeDuplicates(),
            $selectedCountry.removeDuplicates())
            .map { _ in SearchBy.zipcode }
        
        let locationPub = Publishers.CombineLatest(
            $lon.removeDuplicates(),
            $lat.removeDuplicates())
            .map { _ in SearchBy.location }
        
        let namePub = $name.removeDuplicates().map { _ in SearchBy.name }
        
        Publishers.Merge3(
            namePub,
            zipCodePub,
            locationPub)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .print()
            .prepend([SearchBy.name])
            .flatMap { [weak self] searchBy -> AnyPublisher<Result<WeatherModel, AFError>, Never> in
                guard let self = self,
                      searchBy == self.searchBy
                    else { return Empty().eraseToAnyPublisher() }
                switch searchBy {
                case .name:
                    guard !self.name.isEmpty else { return Empty().eraseToAnyPublisher() }
                    return NetworkManager.shared.getWeatherByCityName(name: self.name)
                case .zipcode:
                    guard !self.zipcode.isEmpty && !self.selectedCountry.isEmpty
                        else { return Empty().eraseToAnyPublisher() }
                    return NetworkManager.shared.getWeatherByZipcode(code: self.zipcode, country: self.selectedCountry)
                case .location:
                    guard !self.lon.isEmpty && !self.lat.isEmpty else { return Empty().eraseToAnyPublisher() }
                    return NetworkManager.shared.getWeatherByGPS(lon: self.lon, lat: self.lat)
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
                switch result {
                case .failure(let error):
                    self?.errorMessage = error.errorDescription
                    self?.weatherModel = nil
                case .success(let weatherModel):
                    self?.weatherModel = weatherModel
                    self?.errorMessage = nil
                    self?.searches = UserDefaultsManager.shared.addSearch(weatherModel)
                }
            }
            .store(in: &bag)
    
    }

}
