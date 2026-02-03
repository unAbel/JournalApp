//
//  EntryValidator.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation


struct EntryValidator {
    static let maxLength = 1_000
    static let minLength = 1
    static let maxPhotos = 5
    
    static func validate(text: String, photoCount: Int = 0) throws {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.count < minLength {
            throw EntryError.textTooShort
        }
        
        if trimmed.count > maxLength {
            throw EntryError.textTooLong
        }
        
        if photoCount > maxPhotos {
            throw EntryError.tooManyPhotos
        }
    }
}
