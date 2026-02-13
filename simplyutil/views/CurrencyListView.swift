//
//  CurrencyListView.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import SwiftUI
import SwiftData

struct CurrencyListView: View {
    let currency: String
    
    @Query(sort: \FavoriteEntity.name) private var favorites: [FavoriteEntity]
    @State private var currencyToRate: [String: Double] = [:]
    @State private var amount: Double?
    @State private var isLoading = false
    @State private var error: Error?
    @FocusState private var isFocused: Bool
    
    private var relevantCurrencies: [String] {
        favorites
            .filter { $0.currency != currency }
            .map { $0.currency }
            .uniqued()
            .sorted()
    }
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    Image(currency)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    TextField(
                        "Enter amount",
                        value: $amount,
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .font(.system(.title, design: .rounded, weight: .semibold))
                    .focused($isFocused)
                    
                    Text(Currency.currency(for: currency)?.shortestSymbol ?? currency)
                        .font(.system(.title, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            } header: {
                Text("From")
            }
            
            if isLoading {
                Section {
                    HStack {
                        ProgressView()
                        Text("Loading exchange rates...")
                            .foregroundStyle(.secondary)
                    }
                }
            } else if let error = error {
                Section {
                    ContentUnavailableView {
                        Label("Unable to Load Rates", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error.localizedDescription)
                    } actions: {
                        Button("Try Again") {
                            Task {
                                await loadRates(for: currency)
                            }
                        }
                    }
                }
            } else if relevantCurrencies.isEmpty {
                Section {
                    ContentUnavailableView(
                        "No Other Currencies",
                        systemImage: "banknote",
                        description: Text("Add favorite cities with different currencies to see exchange rates")
                    )
                }
            } else {
                Section {
                    ForEach(relevantCurrencies, id: \.self) { targetCurrency in
                        HStack(spacing: 12) {
                            Image(targetCurrency)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Spacer()
                            
                            if let rate = currencyToRate[targetCurrency] {
                                let convertedAmount = (amount ?? 0) * rate
                                let symbol = Currency.currency(for: targetCurrency)?.shortestSymbol ?? targetCurrency
                                Text("\(convertedAmount, specifier: "%.2f") \(symbol)")
                                    .font(.system(.title2, design: .rounded, weight: .medium))
                                    .foregroundStyle(convertedAmount > 0 ? .primary : .secondary)
                            } else {
                                Text("—")
                                    .font(.system(.title2, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("To")
                } footer: {
                    if !currencyToRate.isEmpty {
                        Text("Exchange rates are approximate and may vary")
                            .font(.caption)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocused = false
                }
            }
        }
        .refreshable {
            await loadRates(for: currency)
        }
        .task {
            await loadRates(for: currency)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadRates(for currency: String) async {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        do {
            if let rateData = await WebService().fetchRates(currency: currency) {
                self.currencyToRate = rateData.rates
            }
        } catch {
            self.error = error
        }
    }
}

// MARK: - Array Extension

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

#Preview {
    CurrencyListView(currency: "USD")
}
