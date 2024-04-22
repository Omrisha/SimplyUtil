//
//  PaginatedView.swift
//  simplyutil
//
//  Created by Omri Shapira on 19/04/2024.
//

import SwiftUI
import SwiftData

struct PaginatedView<Content: View>: View {
    var itemPerPage: Int = 50
    @Binding var paginationOffset: Int?
    @Binding var searchQuery: String
    @ViewBuilder var content: ([CityEntity]) -> Content
    @Environment(\.modelContext) var modelContext
    @State private var cities: [CityEntity] = []
    
    var body: some View {
        content(cities)
            .onChange(of: paginationOffset, initial: false) { oldValue, newValue in
                do {
                    guard let newValue else { return }
                    var fetchDescriptor = FetchDescriptor<CityEntity>(
                        predicate: #Predicate {
                            if searchQuery.isEmpty {
                                return true
                            } else {
                                return $0.name.localizedStandardContains(searchQuery)
                            }
                        },
                        sortBy: [
                            .init(\.name)
                        ]
                    )
                    let totalCount = try modelContext.fetchCount(fetchDescriptor)
                    fetchDescriptor.fetchLimit = itemPerPage
                    let pageOffset = min(min(totalCount, newValue), cities.count)
                    print("Page offset: \(pageOffset)")
                    fetchDescriptor.fetchOffset = pageOffset
                    if totalCount == cities.count {
                        paginationOffset = totalCount
                    } else {
                        let newData = try modelContext.fetch(fetchDescriptor)
                        cities.append(contentsOf: newData)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            .onChange(of: searchQuery, {
                do {
                    var fetchDescriptor = FetchDescriptor<CityEntity>(
                        predicate: #Predicate {
                            if searchQuery.isEmpty {
                                return true
                            } else {
                                return $0.name.localizedStandardContains(searchQuery)
                            }
                        },
                        sortBy: [
                            .init(\.name)
                        ]
                    )
                    let totalCount = try modelContext.fetchCount(fetchDescriptor)
                    fetchDescriptor.fetchLimit = itemPerPage
                    let newData = try modelContext.fetch(fetchDescriptor)
                    cities = newData
                } catch {
                    print(error.localizedDescription)
                }
            })
    }
}
