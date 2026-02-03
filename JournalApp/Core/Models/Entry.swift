//
//  Entry.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation
import SwiftData

import SwiftUI

// Asegúrate de que tu modelo Entry tenga una relación con un modelo Photo, y usa @Attribute(.externalStorage) en el campo del Data de la imagen. Si no haces esto, la base de datos crecerá demasiado y la app irá lenta.

@Model
final class Entry {
    
    @Attribute(.unique)
    var id: UUID
    
    var text: String
    
    var moodRawValue: Int
    
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Photo.entry)
    var photos: [Photo] = []
    
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



@Model
final class Photo {
    @Attribute(.unique)
    var id: UUID
    
    @Attribute(.externalStorage)
    var imageData: Data
    
    var entry: Entry?
    
    init(id: UUID = UUID(), imageData: Data) {
        self.id = id
        self.imageData = imageData
    }
}
