//
//  CreateEntryView.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import SwiftUI

struct CreateEntryView: View {
    
    @Environment(AppContainer.self) private var container
    @Environment(\.dismiss) private var dismiss
    
    @State private var text = ""
    @State private var mood: Mood = .neutral
    @State private var errorMessage: String?
    
    let entryToEdit: Entry?
    
    init(entry: Entry? = nil) {
        self.entryToEdit = entry
        _text = State(initialValue: entry?.text ?? "")
        _mood = State(initialValue: entry?.mood ?? .neutral)
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Text") {
                    TextEditor(text: $text)
                        .frame(minHeight: 120)
                }
                
                Section("Mood") {
                    Picker("Mood", selection: $mood) {
                        ForEach(Mood.allCases, id: \.self) {
                            Text(String(describing: $0))
                                .tag($0)
                        }
                    }
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle(entryToEdit == nil ? "New Entry" : "Edit Entry")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await save()
                        }
                    }
                }
            }
        }
    }
    
    private func save() async {
        do {
            if let entryToEdit {
                try await container.updateEntryUseCase.execute(
                    entry: entryToEdit,
                    newText: text,
                    newMood: mood
                )
            } else {
                try await container.createEntryUseCase.execute(
                    text: text,
                    mood: mood
                )
            }
            
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
