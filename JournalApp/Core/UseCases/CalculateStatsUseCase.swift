//
//  CalculateStatsUseCase.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation

final class CalculateStatsUseCase {
    
    func execute(entries: [Entry]) -> StatsSummary {
        let totalEntries = entries.count
        let currentStreak = calculateStreak(from: entries)
        let entriesPerDay = calculateEntriesPerDay(from: entries)
        
        return StatsSummary(
            totalEntries: totalEntries,
            currentStreak: currentStreak,
            entriesPerDay: entriesPerDay
        )
    }
    
    // MARK: - Private
    
    private func calculateEntriesPerDay(from entries: [Entry]) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        
        // Agrupar por día
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.createdAt)
        }
        
        // Convertir a array y ordenar
        return grouped
            .map { (date: $0.key, count: $0.value.count) }
            .sorted { $0.date < $1.date }
    }
    
    private func calculateStreak(from entries: [Entry]) -> Int {
        guard !entries.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Set de días con entries
        let daysWithEntries = Set(
            entries.map { calendar.startOfDay(for: $0.createdAt) }
        )
        
        var streak = 0
        var currentDate = today
        
        // Contar días consecutivos hacia atrás desde hoy
        while daysWithEntries.contains(currentDate) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousDay
        }
        
        return streak
    }
}
