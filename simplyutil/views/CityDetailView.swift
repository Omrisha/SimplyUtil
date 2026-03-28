//
//  CityDetailView.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI
import Combine

struct CityDetailView: View {
    let city: FavoriteEntity
    
    @State private var temperatureKind = true
    @State private var selectedTab = 0
    @State private var navigationPath = NavigationPath()
    @State private var cachedLandmarks: [Landmark]?
    @State private var isLoadingLandmarks = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CurrencyListView(currency: city.currency)
                .tabItem {
                    Label("Rates", systemImage: "dollarsign.arrow.circlepath")
                }
                .tag(0)
            
            ForecastView(cityName: city.name, tempKind: $temperatureKind)
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }
                .tag(1)
            
            NavigationStack(path: $navigationPath) {
                LandmarkList(
                    cityName: city.name,
                    country: city.country,
                    cachedLandmarks: $cachedLandmarks,
                    isLoadingLandmarks: $isLoadingLandmarks
                )
                .navigationDestination(for: Landmark.self) { landmark in
                    LandmarkDetail(landmark: landmark)
                }
            }
            .tabItem {
                Label("Places", systemImage: "map")
            }
            .tag(2)
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if selectedTab == 1 {
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("Temperature Unit", selection: $temperatureKind) {
                        Text("°C").tag(true)
                        Text("°F").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                }
            }
        }
    }
}

#Preview {
    do {
        let favorite2 = FavoriteEntity(id: 1, name: "Rishon LeZion", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true)
        return CityDetailView(city: favorite2)
    } catch {
        fatalError("Failed to create model container")
    }
}
