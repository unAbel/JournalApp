//
//  TimelineViewModel.swift
//  JournalApp
//
//  Created by Abel on 31/01/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class TimelineViewModel {
    
    private let repository: EntryRepository
    
    var entries: [Entry] = []
    var isLoading = false
    var errorMessage: String?
    var searchText = ""
    
    private var searchTask: Task<Void, Never>?
    
    init(repository: EntryRepository) {
        self.repository = repository
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            entries = try await repository.fetchAll()
        } catch {
            errorMessage = "Failed to load entries"
        }
    }
    
    func search() {
        searchTask?.cancel()
        
        guard !searchText.isEmpty else {
            Task { await load() }
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            
            isLoading = true
            defer { isLoading = false }
            
            do {
                entries = try await repository.search(query: searchText)
            } catch {
                errorMessage = "Search failed"
            }
        }
    }
    
    func delete(_ entry: Entry) async {
        do {
            try await repository.delete(entry)
            await load()
        } catch {
            errorMessage = "Failed to delete entry"
        }
    }
}
