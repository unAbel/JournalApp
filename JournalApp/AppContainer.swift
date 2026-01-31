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

@MainActor
@Observable          // Permitir inyección vía Environment
final class AppContainer {

    let modelContainer: ModelContainer
    let entryRepository: EntryRepository


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


        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}

