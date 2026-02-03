//
//  CreateEntryUseCase.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation
import SwiftData

final class CreateEntryUseCase {
    private let repository: EntryRepository
    private let context: ModelContext
    
    init(repository: EntryRepository, context: ModelContext) {
        self.repository = repository
        self.context = context
    }
    
    func execute(text: String, mood: Mood, photoDataArray: [Data]) async throws {
        try EntryValidator.validate(text: text, photoCount: photoDataArray.count)
        
        let entry = Entry(text: text, mood: mood)
        
        for data in photoDataArray {
            let photo = Photo(imageData: data)
            entry.photos.append(photo)
            context.insert(photo)
        }
        
        try await repository.save(entry)
    }
}
