//
//  CreateEntryViewModel.swift
//  JournalApp
//
//  Created by Abel on 31/01/26.
//

import Foundation
//import Observation

import SwiftUI
import PhotosUI

@MainActor
@Observable
final class CreateEntryViewModel {
    var text: String
    var mood: Mood
    var selectedPhotos: [PhotosPickerItem] = []
    var photoDataArray: [Data] = []
    var isSaving = false
    var errorMessage: String?
    
    private let entry: Entry?
    private let createUseCase: CreateEntryUseCase
    private let updateUseCase: UpdateEntryUseCase
    
    var isValid: Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= EntryValidator.minLength &&
               trimmed.count <= EntryValidator.maxLength &&
               photoDataArray.count <= EntryValidator.maxPhotos
    }
    
    var canAddMorePhotos: Bool {
        photoDataArray.count < EntryValidator.maxPhotos
    }
    
    init(
        entry: Entry? = nil,
        createUseCase: CreateEntryUseCase,
        updateUseCase: UpdateEntryUseCase
    ) {
        self.entry = entry
        self.text = entry?.text ?? ""
        self.mood = entry?.mood ?? .neutral
        self.photoDataArray = entry?.photos.compactMap { $0.imageData } ?? []
        self.createUseCase = createUseCase
        self.updateUseCase = updateUseCase
    }
    
    func loadPhotos() async {
        photoDataArray.removeAll()
        
        for item in selectedPhotos {
            if let data = try? await item.loadTransferable(type: Data.self) {
                photoDataArray.append(data)
                if photoDataArray.count >= EntryValidator.maxPhotos {
                    break
                }
            }
        }
    }
    
    func removePhoto(at index: Int) {
        photoDataArray.remove(at: index)
        selectedPhotos.remove(at: index)
    }
    
    func save() async -> Bool {
        guard isValid else {
            errorMessage = "Invalid entry data"
            return false
        }
        
        isSaving = true
        errorMessage = nil
        defer { isSaving = false }
        
        do {
            if let entry {
                try await updateUseCase.execute(
                    entry: entry,
                    newText: text,
                    newMood: mood,
                    photoDataArray: photoDataArray
                )
            } else {
                try await createUseCase.execute(
                    text: text,
                    mood: mood,
                    photoDataArray: photoDataArray
                )
            }
            
            NotificationCenter.default.post(name: .entryDidChange, object: nil)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}

extension Notification.Name {
    static let entryDidChange = Notification.Name("entryDidChange")
}
