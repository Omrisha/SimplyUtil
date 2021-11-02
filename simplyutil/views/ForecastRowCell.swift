//
//  ForecastRowCell.swift
//  SimplyForecast
//
//  Created by Omri Shapira on 24/10/2019.
//  Copyright © 2019 Omri Shapira. All rights reserved.
//

import SwiftUI

struct ForecastRowCell: View {
    var day: ForecastData
    
    var body: some View {
        HStack {
            Image(day.symbol)
                .resizable()
                .frame(width: 64.0, height: 64.0)
                .padding(.leading)
            Spacer()
            Text(day.date)
                .font(.title)
                .fontWeight(.light)
            .foregroundColor(Color.primary)
            Spacer()
            Text("\(day.degrees)°")
                .font(.title)
                .fontWeight(.semibold)
            .padding(.trailing)
            .foregroundColor(Color.primary)
        }
    }
}

struct ForecastRowCell_Previews: PreviewProvider {
    static var previews: some View {
        ForecastRowCell(day: testData[0].forecast[0])
    }
}
