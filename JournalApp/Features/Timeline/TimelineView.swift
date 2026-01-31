//
//  TimelineView.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation
import SwiftUI

struct TimelineView: View {

    @Environment(AppContainer.self) private var container

    @State private var entries: [Entry] = []
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    emptyState
                } else {
                    listView
                }
            }
            .navigationTitle("Journal")
            .task {
                await loadEntries()
            }
        }
    }

    private var listView: some View {
        List(entries) { entry in
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.text)
                    .lineLimit(2)

                Text(entry.createdAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Entries",
            systemImage: "book.closed",
            description: Text("Start writing your first journal entry")
        )
    }

    private func loadEntries() async {
        isLoading = true
        defer { isLoading = false }

        do {
            entries = try await container.entryRepository.fetchAll()
        } catch {
            print("Failed to load entries: \(error)")
        }
    }
}

#Preview {
    let container = AppContainer(inMemory: true)
    
    return TimelineView()
        .environment(container)
        .modelContainer(container.modelContainer)
}
