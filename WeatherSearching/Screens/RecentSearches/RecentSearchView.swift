//
//  RecentSearchView.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//

import SwiftUI

struct RecentSearchView: View {
    @ObservedObject var vm : SearchingVM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        List {
            ForEach(vm.searches, id: \.self) { item in
                ZStack {
                    Text(item.name ?? "")
                    Button("", action: {
                        vm.searchBy = .name
                        vm.name = item.name ?? ""
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }.onDelete(perform: self.deleteItem)
            
        }.navigationTitle("History")
        
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        print("before delete")
        print(UserDefaultsManager.shared.searches.count)
        var temp = vm.searches
        temp.remove(atOffsets: indexSet)
        print("after delete")
        print(vm.searches.count)
        vm.searches = temp
        
    }
}
