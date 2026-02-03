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
    @State private var viewModel: TimelineViewModel?
    @State private var showCreateSheet = false
    @State private var entryToEdit: Entry?
    
    var body: some View {
        Group {
            if let viewModel {
                content(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Journal")
        .task {
            guard viewModel == nil else { return }
            let vm = TimelineViewModel(repository: container.entryRepository)
            viewModel = vm
            await vm.load()
        }
        .sheet(isPresented: $showCreateSheet) {
            CreateEntryView(container: container)
            //CreateEntryView()
        }
        .sheet(item: $entryToEdit) { entry in
            CreateEntryView(entry: entry, container: container)
            //CreateEntryView(entry: entry)
        }
        .onReceive(NotificationCenter.default.publisher(for: .entryDidChange)) { _ in
            Task {
                await viewModel?.load()
            }
        }
    }
    
    @ViewBuilder
    private func content(viewModel: TimelineViewModel) -> some View {
        if viewModel.entries.isEmpty {
            emptyState(viewModel: viewModel)
        } else {
            listView(viewModel: viewModel)
        }
    }
    
    private func listView(viewModel: TimelineViewModel) -> some View {
        List {
            ForEach(viewModel.entries) { entry in
                EntryRow(entry: entry)
                    .onTapGesture {
                        entryToEdit = entry
                    }
            }
            .onDelete { indexSet in
                handleDelete(at: indexSet, viewModel: viewModel)
            }
        }
        .searchable(text: Binding(
            get: { viewModel.searchText },
            set: { viewModel.searchText = $0; viewModel.search() }
        ))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func emptyState(viewModel: TimelineViewModel) -> some View {
        Group {
            if viewModel.searchText.isEmpty {
                ContentUnavailableView(
                    "No Entries",
                    systemImage: "book.closed",
                    description: Text("Start writing your first journal entry")
                )
            } else {
                ContentUnavailableView.search
            }
        }
    }
    
    private func handleDelete(at indexSet: IndexSet, viewModel: TimelineViewModel) {
        for index in indexSet {
            let entry = viewModel.entries[index]
            Task {
                await viewModel.delete(entry)
            }
        }
    }
}

// MARK: - Subviews
private struct EntryRow: View {
    let entry: Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.text)
                .lineLimit(2)
            
            Text(entry.createdAt, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
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
