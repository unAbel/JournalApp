//
//  SettingsViewModel.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation
import UserNotifications

@MainActor
@Observable
final class SettingsViewModel {

    private let storage: SettingsStorageProtocol
    private let notificationService: NotificationServiceProtocol
    private let repository: EntryRepository

    private var isBootstrapping = true

    var dailyReminderEnabled: Bool {
        didSet {
            guard !isBootstrapping else { return }
            handleReminderToggle()
        }
    }

    var selectedTheme: AppTheme {
        didSet {
            guard !isBootstrapping else { return }
            saveSettings()
        }
    }

    var isPermissionGranted = false
    var errorMessage: String?
    var isResetting = false

    init(
        storage: SettingsStorageProtocol,
        notificationService: NotificationServiceProtocol,
        repository: EntryRepository
    ) {
        self.storage = storage
        self.notificationService = notificationService
        self.repository = repository

        let state = storage.load()

        self.dailyReminderEnabled = state.dailyReminderEnabled
        self.selectedTheme = state.selectedTheme

        isBootstrapping = false

        loadNotificationPermission()
    }

    // MARK: - Permission state

    private func loadNotificationPermission() {
        Task {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            isPermissionGranted = settings.authorizationStatus == .authorized
        }
    }

    // MARK: - Reminder

    private func handleReminderToggle() {
        Task {
            if dailyReminderEnabled {
                await enableReminder()
            } else {
                disableReminder()
            }
        }
    }

    private func enableReminder() async {

        let granted = await notificationService.requestPermission()

        guard granted else {
            dailyReminderEnabled = false
            isPermissionGranted = false
            errorMessage = "Notification permission denied"
            return
        }

        do {
            try await notificationService.scheduleDailyReminder()
            isPermissionGranted = true
            saveSettings()
        } catch {
            dailyReminderEnabled = false
            errorMessage = "Failed to schedule reminder"
        }
    }

    private func disableReminder() {
        notificationService.cancelDailyReminder()
        saveSettings()
    }

    // MARK: - Reset

    func resetAllData() async {
        isResetting = true
        defer { isResetting = false }

        do {
            try await repository.deleteAll()
            storage.reset()

            let state = storage.load()
            dailyReminderEnabled = state.dailyReminderEnabled
            selectedTheme = state.selectedTheme

            NotificationCenter.default.post(name: .entryDidChange, object: nil)

        } catch {
            errorMessage = "Failed to reset data"
        }
    }

    // MARK: - Persistence

    private func saveSettings() {
        storage.save(
            SettingsState(
                dailyReminderEnabled: dailyReminderEnabled,
                selectedTheme: selectedTheme
            )
        )
    }
}
