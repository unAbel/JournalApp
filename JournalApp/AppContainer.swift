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

// MARK: Dependency Injection Container (DI Container)
// AppContainer Es infraestructura, No debe provocar renders, Global app-scoped dependency
// Environment NO está disponible en init de view
@MainActor          // SwiftData mainContext es MainActor
@Observable         // Permitir inyección vía Environment
final class AppContainer {
    let modelContainer: ModelContainer
    let entryRepository: EntryRepository
    let fetchEntriesUseCase: FetchEntriesUseCase
    let createEntryUseCase: CreateEntryUseCase
    let deleteEntryUseCase: DeleteEntryUseCase
    let updateEntryUseCase: UpdateEntryUseCase
    let calculateStatsUseCase: CalculateStatsUseCase // DAY 5
    let settingsStorage: SettingsStorageProtocol // DAY 6
    let notificationService: NotificationServiceProtocol // DAY 6
    
    // AppContainer debe ser infraestructura. No estado de UI
    var selectedTheme: AppTheme // ← Para RootView DAY 6
    
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
            calculateStatsUseCase = CalculateStatsUseCase() // ← DAY 5
            
            settingsStorage = SettingsStorage() // DAY 6
            notificationService = NotificationService() // DAY 6
            
            selectedTheme = settingsStorage.load().selectedTheme // DAY 6
            
        } catch {
            fatalError("ModelContainer failed: \(error)")
        }
    }
    
    static let preview = AppContainer(inMemory: true)
}




// MARK: - Correcto en AppContainer:
//
//Persistencia
//✔ SwiftData
//✔ UserDefaults wrapper
//✔ Keychain wrapper
//
//Servicios Core
//✔ Network client
//✔ Analytics
//✔ Notifications
//✔ Feature Flags
//✔ Remote Config
//
//Dominio
//✔ Repositories
//✔ UseCases (o Interactors)
//
//Infraestructura
//✔ Environment config (dev/prod)
//✔ API base URL
//✔ Build flags
