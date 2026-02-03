//
//  AppContainer.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation
import SwiftData
import Observation

/// SwiftData → Repository → AppContainer
/// UI → CreateEntryUseCase → Validator → Repository → SwiftData

@MainActor
@Observable          // Permitir inyección vía Environment
final class AppContainer {
    let modelContainer: ModelContainer
    let entryRepository: EntryRepository
    let fetchEntriesUseCase: FetchEntriesUseCase
    let createEntryUseCase: CreateEntryUseCase
    let deleteEntryUseCase: DeleteEntryUseCase
    let updateEntryUseCase: UpdateEntryUseCase
    
    init(inMemory: Bool = false) {
        do {
            let schema = Schema([Entry.self, Photo.self]) // ← Añadir Photo
            let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
            
            let context = modelContainer.mainContext
            entryRepository = SwiftDataEntryRepository(context: context)
            
            fetchEntriesUseCase = FetchEntriesUseCase(repository: entryRepository)
            createEntryUseCase = CreateEntryUseCase(repository: entryRepository, context: context)
            deleteEntryUseCase = DeleteEntryUseCase(repository: entryRepository)
            updateEntryUseCase = UpdateEntryUseCase(repository: entryRepository, context: context)
        } catch {
            fatalError("ModelContainer failed: \(error)")
        }
    }
    
    static let preview = AppContainer(inMemory: true)
}
