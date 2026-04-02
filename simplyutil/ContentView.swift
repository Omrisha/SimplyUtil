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
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteEntity.name) private var favorites: [FavoriteEntity]
    @State private var isAddingCity = false
    @State private var searchQuery = ""
    
    // Filtered favorites based on search
    private var filteredFavorites: [FavoriteEntity] {
        if searchQuery.isEmpty {
            return favorites
        }
        return favorites.filter { favorite in
            favorite.name.localizedCaseInsensitiveContains(searchQuery) ||
            favorite.country.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            Group {
                if filteredFavorites.isEmpty {
                    ContentUnavailableView {
                        Label("No Favorites", systemImage: "star.slash")
                    } description: {
                        Text(searchQuery.isEmpty ? 
                             "Add your favorite cities to get started" : 
                             "No cities match '\(searchQuery)'")
                    } actions: {
                        if searchQuery.isEmpty {
                            Button("Add City") {
                                isAddingCity = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                } else {
                    List {
                        ForEach(filteredFavorites) { item in
                            NavigationLink {
                                CityDetailView(city: item)
                            } label: {
                                CityRow(cityData: item)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteFavorite(item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .searchable(text: $searchQuery, prompt: "Search cities or countries")
            .navigationTitle("Favorite Places")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingCity = true
                    } label: {
                        Label("Add City", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    if !favorites.isEmpty {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $isAddingCity) {
                CitiesListView()
            }
        } detail: {
            ContentUnavailableView {
                Label("Select a Favorite", systemImage: "star")
            } description: {
                Text("Choose a city from your favorites to see more details")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            for offset in offsets {
                let favorite = filteredFavorites[offset]
                modelContext.delete(favorite)
            }
        }
    }
    
    private func deleteFavorite(_ favorite: FavoriteEntity) {
        withAnimation {
            modelContext.delete(favorite)
        }
    }
}

#Preview("With Favorites") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FavoriteEntity.self, configurations: config)
    let favorites = [
        FavoriteEntity(cityId: 1, name: "Ramat Gan", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true),
        FavoriteEntity(cityId: 2, name: "Tel Aviv", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true)
    ]
    favorites.forEach { container.mainContext.insert($0) }
    return ContentView().modelContainer(container)
}
