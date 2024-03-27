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
    @State var forecasts: [ForecastsDTO] = []
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            TabView {
                List {
                    Section("From") {
                        HStack {
                            Image(city.currency)
                                .resizable()
                                .frame(width: 45, height: 45)
                            TextField("Enter amount", value: $amount, format: .number)
                                .keyboardType(.decimalPad)
                                .submitLabel(.done)
                                .multilineTextAlignment(.center)
                                .font(.largeTitle)
                                .padding([.trailing, .leading])
                        }
                    }
                    Section("To") {
                        ForEach(rates.sorted(by: >), id: \.key) { key, value in
                            
                            HStack {
                                Image(key)
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                Text("\((self.amount ?? 0) * (self.currencyToRate[key] ?? 0), specifier: "%.2f")")
                                    .font(.title)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }
                .tabItem {
                    Label("Rates", systemImage: "dollarsign.arrow.circlepath")
                }
                List {
                    ForEach(forecasts) { forecast in
                        ForecastRowCell(days: forecast)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .tabItem {
                    Label("Weather", systemImage: "sun.max.circle")
                }
                Text("Places")
                    .tabItem {
                        Label("Recommendation", systemImage: "checkmark.seal")
                    }
            }
        }
        .navigationTitle("\(city.name), \(city.threeLetterCode)")
        .ignoresSafeArea()
        .onAppear {
            Task.init{
                await loadForecast(for: city.name)
                
                await loadRates(for: city.currency)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    dismiss()
                }) {
                    Label("Back", systemImage: "arrow.left.circle")
                }
            }
        }
    }
    
    func loadForecast(for cityName: String) async {
        if let forecast = await WebService().fetchWeather(cityName: cityName) {
            self.forecasts = forecast.forecast.forecasts
        }
    }
    
    func loadRates(for currency: String) async {
        if let rates = await WebService().fetchRates(currency: currency) {
            self.currencyToRate = rates.rates
            print(rates.rates)
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
