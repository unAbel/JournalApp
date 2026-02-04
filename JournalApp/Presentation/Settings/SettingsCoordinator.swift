//
//  SettingsCoordinator.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import SwiftUI

struct SettingsCoordinator: View {

    let container: AppContainer

    var body: some View {

        let viewModel = SettingsViewModel(
            storage: container.settingsStorage,
            notificationService: container.notificationService,
            repository: container.entryRepository
        )

        SettingsView(viewModel: viewModel)
    }
}
