//
//  UpdateEntryUseCase.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation
import SwiftData

@MainActor
final class UpdateEntryUseCase {

    private let repository: EntryRepository
    private let context: ModelContext

    init(repository: EntryRepository, context: ModelContext) {
        self.repository = repository
        self.context = context
    }

    func execute(
        entry: Entry,
        newText: String,
        newMood: Mood,
        photoDataArray: [Data]
    ) async throws {

        try EntryValidator.validate(
            text: newText,
            photoCount: photoDataArray.count
        )

        entry.text = newText
        entry.mood = newMood
        entry.updatedAt = .now

        // Eliminar fotos (cascade ya está definido)
        entry.photos.forEach { context.delete($0) }
        entry.photos.removeAll()

        // Agregar nuevas
        for data in photoDataArray {
            let photo = Photo(imageData: data, entry: entry)
            entry.photos.append(photo)
        }

        try await repository.save()   // 👈 NO insert
    }
}
