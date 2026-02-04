//
//  Mood.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import Foundation

//enum Mood: Int, CaseIterable, Codable {
//    case veryBad = 0
//    case bad
//    case neutral
//    case good
//    case veryGood
//}

enum Mood: Int, CaseIterable, Codable, Hashable {
    case veryBad = 0
    case bad
    case neutral
    case good
    case veryGood
}

extension Mood {
    var displayName: String {
        switch self {
        case .veryBad: "😢"
        case .bad: "😕"
        case .neutral: "😐"
        case .good: "🙂"
        case .veryGood: "😄"
        }
    }
}
