//
//  CitiesListView.swift
//  simplyutil
//
//  Created by Omri Shapira on 21/03/2024.
//

import SwiftUI
import SwiftData

struct CitiesListView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query(sort: \CityEntity.name) var cities: [CityEntity]
    
    var body: some View {
        List(cities, id: \.id) { city in
            AsyncButton(action: {
                await WebService().createModelInDatabase(item: city, modelContext: modelContext)
                
                dismiss()
            }, label: {
                HStack {
                    Text(city.name)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.title3)
                    Spacer()
                    Text(city.country)
                        .font(.subheadline)
                        
                }
            })
        }
        .overlay {
            if cities.isEmpty {
                Text("No Results")
            }
        }
        .task {
            if cities.isEmpty {
                await WebService().updateDataInDatabase(modelContext:   modelContext)
            }
        }
    }
    
    init(sort: SortDescriptor<CityEntity>, searchText: String) {
        _cities = Query(filter: #Predicate {
            if searchText.isEmpty {
                return true
            } else {
                return $0.name.localizedStandardContains(searchText)
            }
        }, sort: [sort])
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
