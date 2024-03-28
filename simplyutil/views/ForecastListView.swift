//
//  ForecastListView.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import SwiftUI

struct ForecastListView: View {
    var cityName: String
    @State var forecasts: [ForecastsDTO] = []
    @Binding var tempKind: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(forecasts) { forecast in
                    ForecastRowCell(
                        days: forecast,
                        tempType: $tempKind)
                        .listRowInsets(EdgeInsets())
                }
            }
        }
        .onAppear {
            Task.init {
                await loadForecast(for: cityName)
            }
        }
    }
    
    func loadForecast(for cityName: String) async {
        if let forecast = await WebService().fetchWeather(cityName: cityName) {
            self.forecasts = forecast.forecast.forecasts
        }
    }
}

#Preview {
    ForecastListView(cityName: "Tel Aviv", tempKind: Binding.constant(true))
}
