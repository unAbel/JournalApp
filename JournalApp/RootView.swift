//
//  RootView.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import SwiftUI

struct RootView: View {

    var body: some View {
        TabView {
            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage: "list.bullet")
                }
        }
    }
}
