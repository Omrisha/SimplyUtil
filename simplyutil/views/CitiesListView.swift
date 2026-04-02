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
    @Query private var favorites: [FavoriteEntity]
    @State private var cities: [CityDTO] = []
    @State private var searchQuery: String = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var currentPage = 1
    @State private var isLoading = false
    @State private var hasMorePages = true
    @State private var totalCount = 0
    @State private var errorMessage: String?
    @State private var showingDuplicateAlert = false
    @State private var duplicateCityName = ""
    
    private let pageSize = 50
    
    // Helper to check if a city is already a favorite (by name and country)
    private func isFavorite(_ city: CityDTO) -> Bool {
        favorites.contains { 
            $0.name.lowercased() == city.name.lowercased() && 
            $0.country.lowercased() == city.country.lowercased() 
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = errorMessage {
                    ContentUnavailableView {
                        Label("Error Loading Cities", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(errorMessage)
                    } actions: {
                        Button("Retry") {
                            Task {
                                await loadCities(reset: true)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if cities.isEmpty && isLoading {
                    ProgressView("Loading cities...")
                } else if cities.isEmpty {
                    ContentUnavailableView {
                        Label("No Cities Found", systemImage: "magnifyingglass")
                    } description: {
                        Text(searchQuery.isEmpty ? 
                             "No cities available" : 
                             "No cities match '\(searchQuery)'")
                    }
                } else {
                    List {
                        ForEach(Array(cities.enumerated()), id: \.element.id) { index, city in
                            AsyncButton(action: {
                                await addCityToFavorites(city)
                            }, label: {
                                HStack {
                                    Text(city.name)
                                        .fontWeight(.bold)
                                        .font(.title3)
                                    Spacer()
                                    Text(city.country)
                                        .font(.subheadline)
                                }
                            })
                            .onAppear {
                                // Load more when reaching near the end (5 items before last)
                                if index >= cities.count - 5 && hasMorePages && !isLoading {
                                    print("🔄 Triggering pagination at index \(index)/\(cities.count)")
                                    Task {
                                        await loadCities(reset: false)
                                    }
                                }
                            }
                        }
                        
                        if hasMorePages && !cities.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView("Loading more...")
                                    .padding()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $searchQuery, prompt: "Search cities or countries")
            .onChange(of: searchQuery) { oldValue, newValue in
                // Cancel previous search task
                searchTask?.cancel()
                
                // Create new debounced search task
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
                    
                    // Check if task was cancelled
                    guard !Task.isCancelled else { return }
                    
                    // Only search if query is still the same
                    if searchQuery == newValue {
                        print("🔍 Searching for: '\(newValue)'")
                        await loadCities(reset: true)
                    }
                }
            }
            .navigationTitle("Add City (\(totalCount) cities)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .task {
                if cities.isEmpty {
                    await loadCities(reset: true)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadCities(reset: Bool = false) async {
        // Prevent multiple simultaneous loads
        guard !isLoading else {
            print("⚠️ Already loading, skipping")
            return
        }
        
        // Don't load if we've reached the end
        guard hasMorePages || reset else {
            print("⚠️ No more pages, skipping")
            return
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        if reset {
            await MainActor.run {
                currentPage = 1
                cities = []
                hasMorePages = true
            }
        }
        
        print("📡 Loading cities - Page: \(currentPage), Search: '\(searchQuery)'")
        
        do {
            let response = try await UnifiedAPIClient.shared.fetchCities(
                page: currentPage,
                pageSize: pageSize,
                searchQuery: searchQuery
            )
            
            await MainActor.run {
                print("✅ Received \(response.cities.count) cities, total available: \(response.count)")
                
                totalCount = response.count
                cities.append(contentsOf: response.cities)
                hasMorePages = cities.count < response.count
                currentPage += 1
                isLoading = false
                
                print("📊 Current state: \(cities.count)/\(totalCount) cities loaded, hasMore: \(hasMorePages)")
            }
        } catch {
            await MainActor.run {
                print("❌ Error loading cities: \(error)")
                errorMessage = "Failed to load cities: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    private func addCityToFavorites(_ city: CityDTO) async {
        do {
            let favorite = FavoriteEntity(
                cityId: city.id,
                name: city.name,
                threeLetterCode: city.threeLetterCode,
                currency: city.currency,
                country: city.country,
                isFavorite: true
            )
            
            await MainActor.run {
                modelContext.insert(favorite)
                dismiss()
            }
        }
    }
}

extension View {
    @ViewBuilder
    func customOnAppear(_ callOnce: Bool = true, action: @escaping () -> ()) -> some View {
        self
            .modifier(CustomOnAppearModifier(callOnce: callOnce, action: action))
    }
}

fileprivate struct CustomOnAppearModifier: ViewModifier {
    var callOnce: Bool
    var action: () -> ()
    @State private var isTriggered: Bool = false
    func body(content: Content) -> some View {
        content
            .onAppear {
                if callOnce {
                    if !isTriggered {
                        action()
                        isTriggered = true
                    }
                } else {
                    action()
                }
            }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FavoriteEntity.self, configurations: config)
        return CitiesListView().modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
