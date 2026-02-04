//
//  UpdateEntryUseCase.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation
import SwiftData

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
        try EntryValidator.validate(text: newText, photoCount: photoDataArray.count)
        
        entry.text = newText
        entry.mood = newMood
        entry.updatedAt = .now
        
        // Eliminar fotos existentes
        for photo in entry.photos {
            context.delete(photo)
        }
        entry.photos.removeAll()
        
        // Agregar nuevas fotos
        for data in photoDataArray {
            let photo = Photo(imageData: data)
            entry.photos.append(photo)
            context.insert(photo)
        }
        
        try await repository.save(entry)
    }
}
