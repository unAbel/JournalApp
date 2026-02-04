//
//  SettingsView.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import SwiftUI


import SwiftUI

struct SettingsView: View {
    @Environment(AppContainer.self) private var container

    @State var viewModel: SettingsViewModel
    @State private var showResetConfirmation = false

    var body: some View {
        Form {

            Section("Notifications") {
                Toggle("Daily Reminder", isOn: $viewModel.dailyReminderEnabled)

                if !viewModel.isPermissionGranted && viewModel.dailyReminderEnabled {
                    Text("Enable notifications in Settings")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Appearance") {
                Picker("Theme", selection: $viewModel.selectedTheme) {
                    ForEach(AppTheme.allCases, id: \.self) {
                        Text($0.displayName)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {

                    if viewModel.isResetting {
                        ProgressView()
                    } else {
                        Text("Reset All Data")
                    }

                }
                .disabled(viewModel.isResetting)

            } footer: {
                Text("This will delete all entries and reset settings.")
                    .font(.caption)
            }
        }
        .navigationTitle("Settings")
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .confirmationDialog(
            "Reset All Data?",
            isPresented: $showResetConfirmation
        ) {
            Button("Reset", role: .destructive) {
                Task {
                    await viewModel.resetAllData()
                }
            }

            Button("Cancel", role: .cancel) {}
        }
        .onChange(of: viewModel.selectedTheme) { _, newValue in
            container.selectedTheme = newValue
        }
    }
}
