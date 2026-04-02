//
//  simplyutilApp.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI
import SwiftData

@main
struct simplyutilApp: App {
    let modelContainer: ModelContainer
        
    init() {
        do {
            // Only store FavoriteEntity now - cities are fetched directly from API
            modelContainer = try ModelContainer(for: FavoriteEntity.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
