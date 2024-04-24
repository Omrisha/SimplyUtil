//
//  ForecastsListView.swift
//  simplyutil
//
//  Created by Omri Shapira on 24/04/2024.
//

import SwiftUI

struct ForecastsListView: View {
    var forecasts: [ForecastsDTO]
    @Binding var tempKind: Bool
    
    var body: some View {
        if forecasts.count > 0 {
            List {
                ForEach(forecasts.sorted { $0.date.get(.day) < $1.date.get(.day) }) { forecast in
                    ForecastRowCell(
                        forecast: forecast,
                        tempType: $tempKind)
                    .listRowInsets(EdgeInsets())
                }
            }
        } else {
            ProgressView()
        }
    }
}
