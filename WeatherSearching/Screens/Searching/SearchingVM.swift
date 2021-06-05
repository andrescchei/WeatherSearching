//
//  SearchingVM.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//

import Foundation
import Combine
import Alamofire

final class SearchingVM: ObservableObject {
    // input
    @Published var name = ""
    @Published var zipcode = ""
    @Published var location : (String, String) = ("", "")
  
    // output
    @Published var result: Result<WeatherModel, AFError>? = nil
    
    var bag = Set<AnyCancellable>()
    
    init() {
        $name
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .print()
            .flatMap { name in
                return NetworkManager.shared.getWeatherByCityName(name: name)
            }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print("Finished?")
                    break
                }
            }) { [weak self] result in
                print("getWeatherByCityName result \(result)")
                self?.result = result
            }
            .store(in: &bag)

    }

}
