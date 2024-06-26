//
//  CurrencyListView.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import SwiftUI
import SwiftData

struct CurrencyListView: View {
    @Query(sort: \FavoriteEntity.id) var favorites: [FavoriteEntity]
    var currency: String = "USD"
    @State var currencyToRate: [String: Double] = [:]
    @State var rates: [String: Double] = [:]
    @State var amount: Double?
    @FocusState private var focusedField: Bool
    
    var body: some View {
        List {
            Section("From") {
                HStack {
                    Image(currency)
                        .resizable()
                        .frame(width: 45, height: 45)
                    TextField("Enter amount", value: $amount, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .padding([.trailing, .leading])
                        .focused($focusedField)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            Button("Done") {
                                focusedField = false
                            }
                        }
                    }
                    Text("\(Currency.currency(for: currency)!.shortestSymbol)")
                        .font(.largeTitle)
                }
            }
            Section("To") {
                ForEach(rates.sorted(by: >), id: \.key) { key, value in
                    
                    HStack {
                        Image(key)
                            .resizable()
                            .frame(width: 45, height: 45)
                        Text("\((self.amount ?? 0) * (self.currencyToRate[key] ?? 0), specifier: "%.2f")\(Currency.currency(for: key)!.shortestSymbol)")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .onAppear {
            self.rates = favorites.filter { $0.currency != currency }.reduce([String: Double]()) { (dict, item) -> [String: Double] in
                var dict = dict
                dict[item.currency] = 0.0
                return dict
            }
            
            Task.init{
                await loadRates(for: currency)
            }
        }
    }
    
    func loadRates(for currency: String) async {
        if let rates = await WebService().fetchRates(currency: currency) {
            self.currencyToRate = rates.rates
        }
    }
}

#Preview {
    CurrencyListView(currency: "USD")
}
