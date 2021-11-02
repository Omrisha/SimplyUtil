//
//  NewCityForm.swift
//  simplyutil
//
//  Created by Omri Shapira on 02/11/2021.
//

import SwiftUI

struct NewCityForm: View {
    @State var searchQuery: String = ""
    @ObservedObject var cityFinder: CityFinder = CityFinder()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        self.cityFinder.search(searchQuery)
        
        return NavigationView {
            VStack {
                SearchBar(text: $searchQuery)
                List {
                    Section {
                        ForEach(self.cityFinder.results, id: \.self) { city in
                            Button(action: {
                                print(city)
                            }, label: {
                                Text(city)
                            })
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
            .navigationTitle(Text("Search City").foregroundColor(Color.primary))
                .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                    })
                }
            }
        }.accentColor(.primary)
    }
}

struct NewCityForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewCityForm()
            
            NewCityForm()
                .preferredColorScheme(.dark)
        }
    }
}
