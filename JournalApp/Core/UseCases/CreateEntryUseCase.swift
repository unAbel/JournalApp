//
//  CreateEntryUseCase.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation

final class CreateEntryUseCase {

    private let repository: EntryRepository

    init(repository: EntryRepository) {
        self.repository = repository
    }

    func execute(text: String, mood: Mood) async throws {
        try EntryValidator.validate(text: text)

        let entry = Entry(
            text: text,
            mood: mood
        )

        try await repository.save(entry)
    }
}
