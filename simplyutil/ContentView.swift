//
//  ContentView.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State var addCity = false
    
    var body: some View {
        NavigationView {
            CityList(cities: testData)
                .navigationTitle("Simply")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.addCity.toggle()
                        }, label: {
                            Image(systemName: "plus.app")
                                .font(.title2.weight(.medium))
                        })
                            .sheet(isPresented: self.$addCity, content: {
                                NewCityForm()
                            })
                    }
                }
        }.accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
