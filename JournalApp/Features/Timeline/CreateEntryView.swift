//
//  CreateEntryView.swift
//  JournalApp
//
//  Created by Abel on 30/01/26.
//

import SwiftUI
import PhotosUI

struct CreateEntryView: View {
    //@Environment(AppContainer.self) private var container
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CreateEntryViewModel
    
    let entry: Entry?
    
    init(entry: Entry? = nil, container: AppContainer) {
        self.entry = entry  
        _viewModel = State(initialValue: CreateEntryViewModel(
            entry: entry,
            createUseCase: container.createEntryUseCase,
            updateUseCase: container.updateEntryUseCase
        ))
    }
        
    var body: some View {
        NavigationStack {
            form
                .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
                .toolbar { toolbarContent }
                .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                    Button("OK") { viewModel.errorMessage = nil }
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                Task {
                    if await viewModel.save() {
                        dismiss()
                    }
                }
            }
            .disabled(!viewModel.isValid || viewModel.isSaving)
        }
    }
    
    private var form: some View {
        Form {
            Section("Text") {
                TextEditor(text: $viewModel.text)
                    .frame(minHeight: 120)
                
                Text("\(viewModel.text.count) / \(EntryValidator.maxLength)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("Mood") {
                Picker("Mood", selection: $viewModel.mood) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        Text(mood.displayName).tag(mood)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                PhotosPicker(
                    selection: $viewModel.selectedPhotos,
                    maxSelectionCount: EntryValidator.maxPhotos,
                    matching: .images
                ) {
                    Label("Add Photos", systemImage: "photo.on.rectangle.angled")
                }
                .disabled(!viewModel.canAddMorePhotos)
                .onChange(of: viewModel.selectedPhotos) {
                    Task { await viewModel.loadPhotos() }
                }
                
                if !viewModel.photoDataArray.isEmpty {
                    photosGrid
                }
            } header: {
                HStack {
                    Text("Photos")
                    Spacer()
                    Text("\(viewModel.photoDataArray.count) / \(EntryValidator.maxPhotos)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var photosGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
            ForEach(Array(viewModel.photoDataArray.enumerated()), id: \.offset) { index, data in
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(alignment: .topTrailing) {
                            Button {
                                viewModel.removePhoto(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.white, .red)
                            }
                            .offset(x: 4, y: -4)
                        }
                }
            }
        }
    }
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
