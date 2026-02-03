//
//  SwiftDataEntryRepository.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation
import SwiftData
import OSLog

final class SwiftDataEntryRepository: EntryRepository {
    
    private let context: ModelContext
    private let logger = Logger(subsystem: "JournalApp", category: "persistence")
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchAll() async throws -> [Entry] {
        do {
            let descriptor = FetchDescriptor<Entry>(
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            return try context.fetch(descriptor)
        } catch {
            logger.error("Fetch failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func search(query: String) async throws -> [Entry] {
        do {
            let predicate = #Predicate<Entry> {
                $0.text.localizedStandardContains(query)
            }
            
            let descriptor = FetchDescriptor<Entry>(
                predicate: predicate,
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            
            return try context.fetch(descriptor)
        } catch {
            logger.error("Search failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func save(_ entry: Entry) async throws {
        do {
            context.insert(entry)
            try context.save()
        } catch {
            logger.error("Save failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func delete(_ entry: Entry) async throws {
        do {
            context.delete(entry)
            try context.save()
        } catch {
            logger.error("Delete failed: \(error.localizedDescription)")
            throw error
        }
    }
}
