//
//  CityDetailView.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI
import Combine

struct CityDetailView: View {
    var rates: [String] = []
    var city: FavoriteEntity
    @State var valueToConvert: String = ""
    @State var convertedValue: String = ""
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(alignment: .leading) {
                Text("\(city.name), \(city.threeLetterCode)")
                    .font(.largeTitle)
            }
            Spacer()
            TabView {
                List {
                }
                .tabItem {
                    Label("Weather", systemImage: "sun.max.circle")
                }
                Text("Places")
                    .tabItem {
                        Label("Recommendation", systemImage: "checkmark.seal")
                    }
            }.ignoresSafeArea()
        }
    }
}
