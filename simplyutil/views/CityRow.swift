//
//  CityCard.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct CityRow: View {
    var cityData: FavoriteEntity
    @State var amount: String = "0.0"
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(cityData.name)")
                Text(cityData.currency)
                    .font(.caption)
            }
            .padding(.leading)
            Spacer()
            TextField("0.0", text: $amount)
               .overlay(
                   RoundedRectangle(cornerRadius: 20)
                       .stroke(Color.teal)
               )
               .multilineTextAlignment(.center)
                .frame(width: 150)
                .padding([.leading, .trailing])
                .font(.largeTitle)
        }
    }
}

#Preview {
    do {
        let favorite = FavoriteEntity(id: 1, name: "Ramat Gan", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true)
        return CityRow(cityData: favorite)
    } catch {
        fatalError("Failed to create model container")
    }
}