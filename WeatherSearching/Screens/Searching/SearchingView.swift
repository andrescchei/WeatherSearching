//
//  SearchingView.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//

import SwiftUI

struct SearchingView: View {
    @StateObject var vm = SearchingVM()
    @StateObject var locationVM = LocationVM.shared
    
    @State private var errorMessage: String? = nil
    @State private var weatherModel: WeatherModel? = nil
    let searchByAll: [SearchBy] = SearchBy.allCases
    @State private var countries = ResourcesManager.shared.countryList
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Search By:", selection: $vm.searchBy) {
                    ForEach(searchByAll, id: \.self) { _searchBy in
                        Text(_searchBy.getDisplayName())
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: vm.searchBy, perform: { value in
                    if value == .location {
                        locationVM.requestPermission()
                    }
                })
                .frame(maxHeight: 50)

                if vm.searchBy == .zipcode {
                    Picker("", selection: $vm.selectedCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country.name).tag(country.alpha_2)
                        }
                    }
                }

                HStack {
                    switch vm.searchBy {
                    case .name:
                        TextField("\(vm.searchBy.getDisplayName())", text: $vm.name)
                            .padding()
                    case .zipcode:
                        TextField("\(vm.searchBy.getDisplayName())", text: $vm.zipcode)
                            .padding()
                    case .location:
                        Text("Lon: \(locationVM.longitude)")
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                            .padding()
                            .onReceive(locationVM.$longitude, perform: { value in
                                vm.lon = "\(value)"
                            })
                            
                        Text("Lat: \(locationVM.latitude)")
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                            .padding()
                            .onReceive(locationVM.$latitude, perform: { value in
                                vm.lat = "\(value)"
                            })
                    }
                }

                SubscriptionView(
                    content:
                        VStack(spacing: 8.0) {
                            Row(name: "Name:", value: weatherModel?.name)
                            Row(name: "Temp:", value: weatherModel?.main?.temp.toString())
                            Row(name: "Error:", value: errorMessage)
                        },
                    publisher: vm.$result)
                { result in
                    switch result {
                    case .failure(let error):
                        weatherModel = nil
                        errorMessage = error.errorDescription
                    case .success(let wm):
                        weatherModel = wm
                        errorMessage = nil
                    case .none:
                        weatherModel = UserDefaultsManager.shared.searches.first
                        errorMessage = nil
                    }
                }
                
                NavigationLink(destination: RecentSearchView()) {
                    Text("History")
                }
            }.frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationBarHidden(true)
        }
    }
}

private struct Row: View {
    let name: String
    let value: String?
    
    var body: some View {
        HStack(spacing: 8.0) {
            Text(name)
                .font(.headline)
                .frame(alignment: .leading)
                .padding(.leading, 16)
            Text(value ?? "")
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
        }
    }
}


struct SerachingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView()
    }
}

extension Optional where Wrapped == Double {
    func toString() -> String {
        guard let safe = self else { return "" }
        return "\(safe)"
    }
}
