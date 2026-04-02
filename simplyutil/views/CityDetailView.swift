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
            
            LandmarkList(
                cityName: city.name,
                country: city.country
            )
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
    let favorite2 = FavoriteEntity(cityId: 1, name: "Rishon LeZion", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true)
    return CityDetailView(city: favorite2)
}
