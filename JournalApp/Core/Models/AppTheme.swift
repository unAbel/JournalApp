//
//  AppTheme.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable, Codable {
    case system
    case light
    case dark
    
    var displayName: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}
