//
//  NewCityForm.swift
//  simplyutil
//
//  Created by Omri Shapira on 02/11/2021.
//

import SwiftUI
import SwiftData

struct NewCityForm: View {
    @State var searchQuery: String = ""
    
    var body: some View {
        return NavigationView {
            CitiesListView(sort: SortDescriptor(\CityEntity.name), searchText: searchQuery)
                .searchable(text: $searchQuery)
        }
        
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CityEntity.self, configurations: config)
        let sampleObject = CityEntity(id: 1, name: "Rishon LeZion", threeLetterCode: "ISR", currency: "ILS", country: "Israel")
        container.mainContext.insert(sampleObject)
        return NewCityForm().modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
