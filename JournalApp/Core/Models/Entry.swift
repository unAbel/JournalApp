//
//  Entry.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation
import SwiftData

@Model
final class Entry {

    @Attribute(.unique)
    var id: UUID

    var text: String

    var moodRawValue: Int

    var createdAt: Date
    var updatedAt: Date

    // Photos relationship se agrega más adelante

    init(
        id: UUID = UUID(),
        text: String,
        mood: Mood,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.text = text
        self.moodRawValue = mood.rawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var mood: Mood {
        get { Mood(rawValue: moodRawValue)! }
        set { moodRawValue = newValue.rawValue }
    }
}
