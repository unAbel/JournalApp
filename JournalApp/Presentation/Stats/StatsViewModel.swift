//
//  StatsViewModel.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation

@MainActor
@Observable
final class StatsViewModel {
    
    private let repository: EntryRepository
    private let calculateStatsUseCase: CalculateStatsUseCase
    
    var summary: StatsSummary?
    var isLoading = false
    var errorMessage: String?
    
    init(
        repository: EntryRepository,
        calculateStatsUseCase: CalculateStatsUseCase
    ) {
        self.repository = repository
        self.calculateStatsUseCase = calculateStatsUseCase
    }
    
    func loadStats() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let entries = try await repository.fetchAll()
            summary = calculateStatsUseCase.execute(entries: entries)
        } catch {
            errorMessage = "Failed to load stats"
        }
    }
}
