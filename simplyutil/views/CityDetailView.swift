//
//  CityDetailView.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI
import Combine

struct CityDetailView: View {
    var city: FavoriteEntity
    @State var amount: Double?
    @State private var temperatureKind: Bool = true
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            CurrencyListView(currency: city.currency)
            .tabItem {
                Label("Rates", systemImage: "dollarsign.arrow.circlepath")
            }.tag(0)
            ForecastView(cityName: city.name, tempKind: $temperatureKind)
            .tabItem {
                Label("Weather", systemImage: "sun.max.circle")
            }.tag(1)
            LandmarkList(cityName: city.name, country: city.country)
                .tabItem {
                    Label("Recommendation", systemImage: "checkmark.seal")
                }.tag(2)
        }
        .navigationBarTitle("\(city.name), \(city.threeLetterCode)")
        .toolbar{
            if selectedTab == 1 {
                ToolbarItem(placement: .navigationBarTrailing){
                    Toggle(isOn: $temperatureKind) {
                        Text(temperatureKind ? "C" : "F")
                            .fontWeight(.bold)
                    }
                    .toggleStyle(.switch)
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
