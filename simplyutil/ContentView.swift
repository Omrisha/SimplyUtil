//
//  ContentView.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FavoriteEntity.id) var favorites: [FavoriteEntity]
    @State var addCity = false
    @State private var swipedItemId: Int?
    @State var searchQuery: String = ""
    
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 150)),
        GridItem(.adaptive(minimum: 150, maximum: 150))
    ]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(favorites) { item in
                    NavigationLink {
                        CityDetailView(city: item)
                    } label: {
                        CityRow(cityData: item)
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Favorite Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.addCity.toggle()
                    }, label: {
                        Image(systemName: "plus.app")
                            .font(.title2.weight(.medium))
                    })
                    .sheet(isPresented: self.$addCity, content: {
                        CitiesListView()
                    })
                }
            }
            .accentColor(.primary)
        } detail: {
            Text("Select a favorite")
        }
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our query
            let favorite = favorites[offset]

            // delete it from the context
            modelContext.delete(favorite)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FavoriteEntity.self, CityEntity.self, configurations: config)
        let sampleObject = CityEntity(id: 1, name: "Rishon LeZion", threeLetterCode: "ISR", currency: "ILS", country: "Israel")
        let favorite = FavoriteEntity(id: 1, name: "Ramat Gan", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true)
        let favorite2 = FavoriteEntity(id: 1, name: "Rishon LeZion", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true)
        container.mainContext.insert(sampleObject)
        container.mainContext.insert(favorite)
        container.mainContext.insert(favorite2)
        return ContentView().modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
