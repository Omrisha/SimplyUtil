//
//  CitiesListView.swift
//  simplyutil
//
//  Created by Omri Shapira on 21/03/2024.
//

import SwiftUI
import SwiftData

struct CitiesListView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var paginationOffset: Int?
    @State var searchQuery: String = ""
    
    var body: some View {
        NavigationView {
            List {
                PaginatedView(paginationOffset: $paginationOffset, searchQuery: $searchQuery) { cities in
                    ForEach(cities) { city in
                        AsyncButton(action: {
                            await WebService().createModelInDatabase(item: city, modelContext: modelContext)
                            
                            dismiss()
                        }, label: {
                            HStack {
                                Text(city.name)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .font(.title3)
                                Spacer()
                                Text(city.country)
                                    .font(.subheadline)
                                    
                            }
                        })
                        .customOnAppear(false) {
                            if let paginationOffset, cities.last == city {
                                self.paginationOffset = paginationOffset + 50
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchQuery)
            .onAppear {
                if paginationOffset == nil {
                    paginationOffset = 0
                }
            }
        }
    }
}

extension View {
    @ViewBuilder
    func customOnAppear(_ callOnce: Bool = true, action: @escaping () -> ()) -> some View {
        self
            .modifier(CustomOnAppearModifier(callOnce: callOnce, action: action))
    }
}

fileprivate struct CustomOnAppearModifier: ViewModifier {
    var callOnce: Bool
    var action: () -> ()
    @State private var isTriggered: Bool = false
    func body(content: Content) -> some View {
        content
            .onAppear {
                if callOnce {
                    if !isTriggered {
                        action()
                        isTriggered = true
                    }
                } else {
                    action()
                }
            }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CityEntity.self, configurations: config)
        let sampleObject = CityEntity(id: 1, name: "Rishon LeZion", threeLetterCode: "ISR", currency: "ILS", country: "Israel")
        container.mainContext.insert(sampleObject)
        return CitiesListView().modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
