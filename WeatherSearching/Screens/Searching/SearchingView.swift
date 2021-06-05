//
//  SearchingView.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//


import SwiftUI

struct SearchingView: View {
    @ObservedObject var vm = SearchingVM()
    @State private var errorMessage: String? = nil
    @State private var weatherModel: WeatherModel? = nil
    
    var body: some View {
        VStack {
            TextField("City name or zip", text: $vm.name)
                .padding()
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
                    weatherModel = nil
                    errorMessage = nil
                }
            }
        }.frame(maxHeight: .infinity, alignment: .topLeading)
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
