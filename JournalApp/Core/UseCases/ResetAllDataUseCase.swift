//
//  ResetAllDataUseCase.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation

final class ResetAllDataUseCase {
    private let repository: EntryRepository
    private let storage: SettingsStorageProtocol

    init(repository: EntryRepository, storage: SettingsStorageProtocol) {
        self.repository = repository
        self.storage = storage
    }

    func execute() async throws {
        try await repository.deleteAll()
        storage.reset()
        NotificationCenter.default.post(name: .entryDidChange, object: nil)
    }
}
