//
//  StatsSummary.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation

struct StatsSummary {
    let totalEntries: Int
    let currentStreak: Int
    let entriesPerDay: [(date: Date, count: Int)]
}
