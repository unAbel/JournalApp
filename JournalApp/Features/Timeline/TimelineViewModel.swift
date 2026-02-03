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

    private let fetchEntries: FetchEntriesUseCase
    private let deleteEntry: DeleteEntryUseCase

    private(set) var entries: [Entry] = []
    private(set) var isLoading = false

    init(
        fetchEntries: FetchEntriesUseCase,
        deleteEntry: DeleteEntryUseCase
    ) {
        self.fetchEntries = fetchEntries
        self.deleteEntry = deleteEntry
    }

    func loadEntries() async {
        isLoading = true
        defer { isLoading = false }

        do {
            entries = try await fetchEntries.execute()
        } catch {
            entries = []
        }
    }

    func deleteEntry(at offsets: IndexSet) async {
        for index in offsets {
            let entry = entries[index]
            try? await deleteEntry.execute(entry: entry)
        }
        await loadEntries()
    }
}
