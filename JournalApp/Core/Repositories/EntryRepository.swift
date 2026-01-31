//
//  EntryRepository.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation

protocol EntryRepository {
    func fetchAll() async throws -> [Entry]
    func save(_ entry: Entry) async throws
    func delete(_ entry: Entry) async throws
}
