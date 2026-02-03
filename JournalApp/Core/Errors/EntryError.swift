//
//  EntryError.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation

enum EntryError: LocalizedError {
    case textTooShort
    case textTooLong
    case tooManyPhotos
    
    var errorDescription: String? {
        switch self {
        case .textTooShort: "Entry text is too short"
        case .textTooLong: "Entry text exceeds \(EntryValidator.maxLength) characters"
        case .tooManyPhotos: "Maximum \(EntryValidator.maxPhotos) photos allowed"
        }
    }
}
