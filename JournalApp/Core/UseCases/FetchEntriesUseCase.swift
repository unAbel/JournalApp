//
//  FetchEntriesUseCase.swift
//  JournalApp
//
//  Created by Abel on 31/01/26.
//

import Foundation

@MainActor
final class FetchEntriesUseCase {

    private let repository: EntryRepository

    init(repository: EntryRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Entry] {
        try await repository.fetchAll()
    }
}
