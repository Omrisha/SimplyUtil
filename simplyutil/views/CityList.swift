//
//  CityList.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct CityList: View {
    var cities: [CityData]
    
    let columns = [
        GridItem(.flexible(minimum: 150, maximum: 150)),
        GridItem(.flexible(minimum: 150, maximum: 150))
        ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(self.cities) { item in
                    NavigationLink(destination: CityDetailView(city: item), label: {
                        CityCard(cityData: item)
                    })
                }
            }
        }
    }
}

struct CityList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CityList(cities: testData)
            
            CityList(cities: testData)
                .preferredColorScheme(.dark)
        }
    }
}
