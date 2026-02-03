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
    @State private var showCreateSheet = false
    @State private var entryToEdit: Entry?

    var body: some View {
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
        } // Refrescar lista al cerrar sheet
        .onChange(of: showCreateSheet) { _, newValue in
            if newValue == false {
                Task { await loadEntries() }
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        // CREATE
        .sheet(isPresented: $showCreateSheet) {
            CreateEntryView()
        }
        // EDIT
        .sheet(item: $entryToEdit) { entry in
            CreateEntryView(entry: entry)
        }
        
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let entry = entries[index]
            
            Task {
                do {
                    try await container.deleteEntryUseCase.execute(entry: entry)
                    await loadEntries()
                } catch {
                    print("Delete failed: \(error)")
                }
            }
        }
    }

    private var listView: some View {
        List {
            ForEach(entries) { entry in
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.text)
                        .lineLimit(2)
                    
                    Text(entry.createdAt, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                // TAP PARA EDITAR
                .onTapGesture {
                    entryToEdit = entry
                }
            }
            .onDelete(perform: delete)
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
    
    //TimelineView(container: container)
    return TimelineView()
        .environment(container)
        .modelContainer(container.modelContainer)
}
