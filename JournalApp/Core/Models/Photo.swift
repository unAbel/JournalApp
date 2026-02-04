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

    @Attribute(.externalStorage)
    var imageData: Data

    var entry: Entry

    init(imageData: Data, entry: Entry) {
        self.imageData = imageData
        self.entry = entry
    }
}
