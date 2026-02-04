//
//  NotificationService.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    
    func requestPermission() async -> Bool
    //func scheduleDailyReminder() async throws
    func scheduleDailyReminder(hour: Int, minute: Int) async throws
    func cancelDailyReminder()
}


final class NotificationService: NotificationServiceProtocol {

    private let center = UNUserNotificationCenter.current()
    private let reminderId = "daily_reminder"

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(
                options: [.alert, .sound, .badge]
            )
        } catch {
            return false
        }
    }

    func scheduleDailyReminder(
        hour: Int = 20,
        minute: Int = 0
    ) async throws {

        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized else {
            return
        }

        cancelDailyReminder()

        let content = UNMutableNotificationContent()
        content.title = "Daily Journal"
        content.body = "Time to reflect on your day"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: reminderId,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }

    func cancelDailyReminder() {
        center.removePendingNotificationRequests(
            withIdentifiers: [reminderId]
        )
    }
}



final class NotificationService2: NotificationServiceProtocol {
    func scheduleDailyReminder(hour _: Int, minute _: Int) async throws {
        //
    }
    
    
    private let center = UNUserNotificationCenter.current()
    private let reminderId = "daily_reminder"
    
    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }
    
    func scheduleDailyReminder() async throws {
        // Crear contenido
        let content = UNMutableNotificationContent()
        content.title = "Daily Journal"
        content.body = "Time to reflect on your day ✍️"
        content.sound = .default
        
        // Trigger: todos los días a las 20:00
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        // Crear request
        let request = UNNotificationRequest(
            identifier: reminderId,
            content: content,
            trigger: trigger
        )
        
        // Programar
        try await center.add(request)
    }
    
    func cancelDailyReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [reminderId])
    }
}
