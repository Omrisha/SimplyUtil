//
//  CityDetailView.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI
import Combine

struct CityDetailView: View {
    @State var currencyToRate: [String: Double] = [:]
    @State var rates: [String: Double] = [:]
    var city: FavoriteEntity
    @State var amount: Double?
    @State private var temperatureKind: Bool = true
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            CurrencyListView(currency: city.currency, rates: rates)
            .tabItem {
                Label("Rates", systemImage: "dollarsign.arrow.circlepath")
            }.tag(0)
            ForecastListView(cityName: city.name, tempKind: $temperatureKind)
            .tabItem {
                Label("Weather", systemImage: "sun.max.circle")
            }.tag(1)
            LandmarkList(cityName: city.name, country: city.country)
                .tabItem {
                    Label("Recommendation", systemImage: "checkmark.seal")
                }.tag(2)
        }
        .navigationBarTitle("\(city.name), \(city.threeLetterCode)")
        .ignoresSafeArea()
        .onAppear {
            Task.init{
                await loadRates(for: city.currency)
            }
        }
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
    
    func loadRates(for currency: String) async {
        if let rates = await WebService().fetchRates(currency: currency) {
            self.currencyToRate = rates.rates
        }
    }
}

#Preview {
    do {
        let favorite2 = FavoriteEntity(id: 1, name: "Rishon LeZion", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true)
        return CityDetailView(currencyToRate: ["USD": 4.5] ,rates: ["USD": 0.0],
                              city: favorite2)
    } catch {
        fatalError("Failed to create model container")
    }
}
