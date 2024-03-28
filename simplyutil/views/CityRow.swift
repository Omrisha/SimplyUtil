//
//  CityCard.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct CityRow: View {
    var cityData: FavoriteEntity
    @State var amount: Double?
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("\(cityData.name)")
            Spacer()
            Image(cityData.currency)
                .resizable()
                .frame(width: 45, height: 45)
        }.padding([.leading, .trailing])
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
