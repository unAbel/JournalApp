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
final class AppContainer2 {

    let modelContainer: ModelContainer
    let entryRepository: EntryRepository
    let createEntryUseCase: CreateEntryUseCase
    let deleteEntryUseCase: DeleteEntryUseCase
    let updateEntryUseCase: UpdateEntryUseCase


    init(inMemory: Bool = false) {
        do {
            
            let schema = Schema([
                Entry.self
            ])

            
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: inMemory
            )

            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            
            let context = modelContainer.mainContext
            self.entryRepository = SwiftDataEntryRepository(context: context)


            self.createEntryUseCase = CreateEntryUseCase(repository: entryRepository)
            self.deleteEntryUseCase = DeleteEntryUseCase(repository: entryRepository)
            self.updateEntryUseCase = UpdateEntryUseCase(repository: entryRepository)


        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}


@MainActor
@Observable          // Permitir inyección vía Environment
final class AppContainer {

    let modelContainer: ModelContainer

    // Repository
    let entryRepository: EntryRepository

    // UseCases
    let fetchEntriesUseCase: FetchEntriesUseCase
    let createEntryUseCase: CreateEntryUseCase
    let deleteEntryUseCase: DeleteEntryUseCase
    let updateEntryUseCase: UpdateEntryUseCase

    init(inMemory: Bool = false) {
        do {
            let schema = Schema([Entry.self])
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: inMemory
            )

            modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )

            let context = modelContainer.mainContext
            entryRepository = SwiftDataEntryRepository(context: context)

            fetchEntriesUseCase = FetchEntriesUseCase(repository: entryRepository)
            createEntryUseCase = CreateEntryUseCase(repository: entryRepository)
            deleteEntryUseCase = DeleteEntryUseCase(repository: entryRepository)
            updateEntryUseCase = UpdateEntryUseCase(repository: entryRepository)

        } catch {
            fatalError("ModelContainer failed: \(error)")
        }
    }
}
