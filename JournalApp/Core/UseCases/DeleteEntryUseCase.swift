//
//  DeleteEntryUseCase.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation

final class DeleteEntryUseCase {

    private let repository: EntryRepository

    init(repository: EntryRepository) {
        self.repository = repository
    }

    func execute(entry: Entry) async throws {
        try await repository.delete(entry)
    }
}
