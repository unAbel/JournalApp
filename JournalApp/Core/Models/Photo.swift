//
//  Photo.swift
//  JournalApp
//
//  Created by Abel on 4/02/26.
//

import Foundation
import SwiftData

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
