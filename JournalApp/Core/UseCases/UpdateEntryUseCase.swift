//
//  UpdateEntryUseCase.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation

final class UpdateEntryUseCase {

    private let repository: EntryRepository

    init(repository: EntryRepository) {
        self.repository = repository
    }

    func execute(entry: Entry, newText: String, newMood: Mood) async throws {
        try EntryValidator.validate(text: newText)

        entry.text = newText
        entry.mood = newMood
        entry.updatedAt = .now

        try await repository.save(entry)
    }
}
