//
//  RootView.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import SwiftUI

struct RootView: View {
    @Environment(AppContainer.self) private var container
    
    var body: some View {
        TabView {
            
            NavigationStack {
                TimelineView()
            }
            .tabItem {
                Label("Timeline", systemImage: "list.bullet")
            }
            
            NavigationStack {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar")
            }
            
            NavigationStack {
                SettingsCoordinator(container: container)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .preferredColorScheme(container.selectedTheme.colorScheme)
        .onReceive(NotificationCenter.default.publisher(for: .settingsDidChange)) { _ in
            container.selectedTheme = container.settingsStorage.load().selectedTheme
        }
    }
}

// Añadir notification
extension Notification.Name {
    //static let entryDidChange = Notification.Name("entryDidChange")
    static let settingsDidChange = Notification.Name("settingsDidChange") // ← Nuevo
}
