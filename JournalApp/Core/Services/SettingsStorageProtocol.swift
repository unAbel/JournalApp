//
//  SettingsStorageProtocol.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation

protocol SettingsStorageProtocol {
    func load() -> SettingsState
    func save(_ settings: SettingsState)
    func reset()
}

final class SettingsStorage: SettingsStorageProtocol {
    
    private enum Keys {
        static let dailyReminderEnabled = "dailyReminderEnabled"
        static let selectedTheme = "selectedTheme"
    }
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func load() -> SettingsState {
        let reminderEnabled = defaults.bool(forKey: Keys.dailyReminderEnabled)
        
        let themeRawValue = defaults.string(forKey: Keys.selectedTheme) ?? AppTheme.system.rawValue
        let theme = AppTheme(rawValue: themeRawValue) ?? .system
        
        return SettingsState(
            dailyReminderEnabled: reminderEnabled,
            selectedTheme: theme
        )
    }
    
    func save(_ settings: SettingsState) {
        defaults.set(settings.dailyReminderEnabled, forKey: Keys.dailyReminderEnabled)
        defaults.set(settings.selectedTheme.rawValue, forKey: Keys.selectedTheme)
    }
    
    func reset() {
        defaults.removeObject(forKey: Keys.dailyReminderEnabled)
        defaults.removeObject(forKey: Keys.selectedTheme)
    }
}
