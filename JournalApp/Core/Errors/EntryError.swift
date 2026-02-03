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

    var errorDescription: String? {
        switch self {
        case .textTooShort:
            return "Entry text is too short."
        case .textTooLong:
            return "Entry text is too long."
        }
    }
}
