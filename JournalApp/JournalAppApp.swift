//
//  JournalAppApp.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import SwiftUI

@main
struct JournalAppApp: App {
    // La referencia no cambia. El objeto vive toda la app. No depende del render cycle
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(container)
                .modelContainer(container.modelContainer)
        }
    }
}
