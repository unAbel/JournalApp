//
//  StatsView.swift
//  JournalApp
//
//  Created by Abel on 3/02/26.
//

import SwiftUI
import Charts

// MARK: Revisar si es necesario container o se puede inyectar
struct StatsView: View {
    
    @Environment(AppContainer.self) private var container
    @State private var viewModel: StatsViewModel?
    
    var body: some View {
        Group {
            if let viewModel {
                content(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Stats")
        .task {
            guard viewModel == nil else { return }
            let vm = StatsViewModel(
                repository: container.entryRepository,
                calculateStatsUseCase: container.calculateStatsUseCase
            )
            viewModel = vm
            await vm.loadStats()
        }
        .onReceive(NotificationCenter.default.publisher(for: .entryDidChange)) { _ in
            Task {
                await viewModel?.loadStats()
            }
        }
    }
    
    @ViewBuilder
    private func content(viewModel: StatsViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let summary = viewModel.summary {
            statsContent(summary: summary)
        } else if let error = viewModel.errorMessage {
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(error)
            )
        }
    }
    
    private func statsContent(summary: StatsSummary) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // Metrics
                HStack(spacing: 20) {
                    StatCard(
                        title: "Total Entries",
                        value: "\(summary.totalEntries)",
                        icon: "book.fill"
                    )
                    
                    StatCard(
                        title: "Current Streak",
                        value: "\(summary.currentStreak)",
                        icon: "flame.fill",
                        accentColor: .orange
                    )
                }
                .padding(.horizontal)
                
                // Chart
                if !summary.entriesPerDay.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Entries Over Time")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart(summary.entriesPerDay, id: \.date) { item in
                            BarMark(
                                x: .value("Date", item.date, unit: .day),
                                y: .value("Count", item.count)
                            )
                            .foregroundStyle(.blue.gradient)
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - StatCard Component
private struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var accentColor: Color = .blue
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(accentColor)
            
            Text(value)
                .font(.title.bold())
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
