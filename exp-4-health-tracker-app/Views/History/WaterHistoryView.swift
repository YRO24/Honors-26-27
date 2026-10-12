//
//  WaterHistoryView.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// Water Consumption History screen displaying historical hydration logs in a List
struct WaterHistoryView: View {
    @ObservedObject var healthModel: HealthModel
    
    @State private var showingClearConfirmation: Bool = false
    @State private var filterSelected: HistoryFilter = .all
    
    enum HistoryFilter: String, CaseIterable {
        case all = "All Logs"
        case today = "Today"
        case previous = "Earlier"
    }
    
    // Group records by calendar day
    private var filteredRecords: [WaterRecord] {
        let calendar = Calendar.current
        switch filterSelected {
        case .all:
            return healthModel.waterRecords
        case .today:
            return healthModel.waterRecords.filter { calendar.isDateInToday($0.date) }
        case .previous:
            return healthModel.waterRecords.filter { !calendar.isDateInToday($0.date) }
        }
    }
    
    private var totalFilteredVolume: Double {
        filteredRecords.reduce(0.0) { $0 + $1.amountInMl }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Summary Header Banner
                historySummaryBanner
                
                // Filter Segmented Control
                Picker("Filter", selection: $filterSelected) {
                    ForEach(HistoryFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                
                // History List (Directly fulfilling required UI component)
                if filteredRecords.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(filteredRecords) { record in
                            WaterRecordRow(record: record, healthModel: healthModel)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            healthModel.deleteRecord(id: record.id)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Hydration History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            healthModel.resetToDemoData()
                        } label: {
                            Label("Reset Demo Data", systemImage: "arrow.counterclockwise")
                        }
                        
                        Button(role: .destructive) {
                            showingClearConfirmation = true
                        } label: {
                            Label("Clear All History", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
            .confirmationDialog(
                "Clear History",
                isPresented: $showingClearConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete All Records", role: .destructive) {
                    withAnimation {
                        healthModel.clearAllRecords()
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently remove all hydration entries.")
            }
        }
    }
    
    // MARK: - Summary Banner
    private var historySummaryBanner: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("TOTAL LOGGED")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text(healthModel.formattedAmount(totalFilteredVolume))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("ENTRIES")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Text("\(filteredRecords.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(UIColor.secondarySystemGroupedBackground))
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "water.waves")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No Hydration Records")
                .font(.headline)
            
            Text("Records you log will appear here in chronological order.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Button("Load Demo Data") {
                withAnimation {
                    healthModel.resetToDemoData()
                }
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.12))
            .foregroundColor(.blue)
            .clipShape(Capsule())
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            // Map offset from filteredRecords to actual healthModel records
            for index in offsets {
                let recordToDelete = filteredRecords[index]
                healthModel.deleteRecord(id: recordToDelete.id)
            }
        }
    }
}

// MARK: - Custom Water Record Row Component
struct WaterRecordRow: View {
    let record: WaterRecord
    let healthModel: HealthModel
    
    var body: some View {
        HStack(spacing: 14) {
            // Container Icon
            Image(systemName: record.containerType.iconName)
                .font(.system(size: 18))
                .foregroundColor(.blue)
                .frame(width: 38, height: 38)
                .background(Color.blue.opacity(0.12))
                .clipShape(Circle())
            
            // Details
            VStack(alignment: .leading, spacing: 3) {
                Text(record.note.isEmpty ? record.containerType.rawValue : record.note)
                    .font(.body)
                    .fontWeight(.medium)
                
                HStack(spacing: 6) {
                    Text(record.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(record.containerType.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Amount
            Text("+\(healthModel.formattedAmount(record.amountInMl))")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    WaterHistoryView(healthModel: HealthModel())
}
