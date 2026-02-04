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
        static let reminderHour = "reminderHour"
        static let reminderMinute = "reminderMinute"
    }
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    
    func load() -> SettingsState {
        let reminderEnabled = defaults.bool(forKey: Keys.dailyReminderEnabled)
        
        let themeRawValue = defaults.string(forKey: Keys.selectedTheme)
        ?? AppTheme.system.rawValue
        let theme = AppTheme(rawValue: themeRawValue) ?? .system
        
        // Defaults reales del sistema
        let hour = defaults.object(forKey: Keys.reminderHour) as? Int ?? 20
        let minute = defaults.object(forKey: Keys.reminderMinute) as? Int ?? 0
        
        return SettingsState(
            dailyReminderEnabled: reminderEnabled,
            selectedTheme: theme,
            reminderHour: hour,
            reminderMinute: minute
        )
    }
    
    func save(_ settings: SettingsState) {
        defaults.set(settings.dailyReminderEnabled, forKey: Keys.dailyReminderEnabled)
        defaults.set(settings.selectedTheme.rawValue, forKey: Keys.selectedTheme)
        defaults.set(settings.reminderHour, forKey: Keys.reminderHour)
        defaults.set(settings.reminderMinute, forKey: Keys.reminderMinute)
    }
    
    func reset() {
        defaults.removeObject(forKey: Keys.dailyReminderEnabled)
        defaults.removeObject(forKey: Keys.selectedTheme)
        defaults.removeObject(forKey: Keys.reminderHour)
        defaults.removeObject(forKey: Keys.reminderMinute)
    }
}
