//
//  SettingsState.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation

struct SettingsState: Codable {
    var dailyReminderEnabled: Bool
    var selectedTheme: AppTheme
    
    static let `default` = SettingsState(
        dailyReminderEnabled: false,
        selectedTheme: .system
    )
}
