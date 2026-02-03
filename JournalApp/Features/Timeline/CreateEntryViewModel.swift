//
//  CreateEntryViewModel.swift
//  JournalApp
//
//  Created by Abel on 31/01/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class CreateEntryViewModel {

    private let createEntry: CreateEntryUseCase
    private let updateEntry: UpdateEntryUseCase?

    var text: String = ""
    var mood: Mood = .neutral
    var errorMessage: String?

    init(
        createEntry: CreateEntryUseCase,
        updateEntry: UpdateEntryUseCase? = nil
    ) {
        self.createEntry = createEntry
        self.updateEntry = updateEntry
    }

    func save(existingEntry: Entry? = nil) async {
        do {
            if let entry = existingEntry {
                try await updateEntry?.execute(
                    entry: entry,
                    newText: text,
                    newMood: mood
                )
            } else {
                try await createEntry.execute(
                    text: text,
                    mood: mood
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
