//
//  ForecastRowCell.swift
//  SimplyForecast
//
//  Created by Omri Shapira on 24/10/2019.
//  Copyright © 2019 Omri Shapira. All rights reserved.
//

import SwiftUI

struct ForecastRowCell: View {
    var days: ForecastsDTO
    
    var body: some View {
        HStack {
            Image(days.day.condition.icon)
                .resizable()
                .frame(width: 64.0, height: 64.0)
                .padding(.leading)
            Spacer()
            Text(days.date)
                .font(.title)
                .fontWeight(.light)
            .foregroundColor(Color.primary)
            Spacer()
            Text("\(days.day.averageTemperatureCelsius)°")
                .font(.title)
                .fontWeight(.semibold)
            .padding(.trailing)
            .foregroundColor(Color.primary)
        }
    }
}
