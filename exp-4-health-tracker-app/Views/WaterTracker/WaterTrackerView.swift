//
//  WaterTrackerView.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// Water Consumption Tracking view allowing users to configure goals and record hydration entries
struct WaterTrackerView: View {
    @ObservedObject var healthModel: HealthModel
    
    // Local @State variables to control UI inputs
    @State private var currentIntakeAmount: Double = 250.0
    @State private var recordDate: Date = Date()
    @State private var selectedContainer: WaterRecord.ContainerType = .glass
    @State private var optionalNote: String = ""
    @State private var showSuccessBanner: Bool = false
    @State private var lastLoggedAmount: Double = 0.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    // Success feedback toast if recently logged
                    if showSuccessBanner {
                        successBanner
                    }
                    
                    // Daily Goal Configuration Card (Uses Slider)
                    dailyGoalSection
                    
                    // Water Intake Logging Card (Uses Stepper, DatePicker, and Buttons)
                    logIntakeCard
                    
                    // Preset Quick-Tap Buttons
                    quickPresetSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Hydration Tracker")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Success Banner
    private var successBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.green)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Hydration Recorded!")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("+\(healthModel.formattedAmount(lastLoggedAmount)) added to your daily progress.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    showSuccessBanner = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1.5)
                )
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    // MARK: - Daily Goal Section (Using Slider)
    private var dailyGoalSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Daily Hydration Target", systemImage: "target")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(healthModel.formattedAmount(healthModel.dailyWaterGoal))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            Text("Adjust your target hydration based on your activity and climate.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Slider to set daily water-consumption goal
            Slider(value: $healthModel.dailyWaterGoal, in: 1000...4500, step: 100)
                .tint(.blue)
            
            HStack {
                Text("1,000 ml")
                Spacer()
                Text("2,500 ml")
                Spacer()
                Text("4,500 ml")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            
            // Goal Preset Chips
            HStack(spacing: 8) {
                ForEach([2000.0, 2500.0, 3000.0, 3500.0], id: \.self) { preset in
                    Button {
                        withAnimation {
                            healthModel.dailyWaterGoal = preset
                        }
                    } label: {
                        Text("\(Int(preset)) ml")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                healthModel.dailyWaterGoal == preset ? Color.blue : Color(UIColor.tertiarySystemGroupedBackground)
                            )
                            .foregroundColor(healthModel.dailyWaterGoal == preset ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.top, 4)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
    
    // MARK: - Log Intake Card (Using Stepper, DatePicker, and Buttons with Subcomponent Binding)
    private var logIntakeCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("Record Water Intake", systemImage: "drop.circle.fill")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text(selectedContainer.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
            }
            
            // Vessel Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(WaterRecord.ContainerType.allCases, id: \.self) { container in
                        Button {
                            selectedContainer = container
                            currentIntakeAmount = container.defaultAmountMl
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: container.iconName)
                                    .font(.system(size: 20))
                                Text(container.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("\(Int(container.defaultAmountMl)) ml")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 76, height: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedContainer == container ? Color.blue.opacity(0.15) : Color(UIColor.tertiarySystemGroupedBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedContainer == container ? Color.blue : Color.clear, lineWidth: 1.5)
                            )
                            .foregroundColor(selectedContainer == container ? .blue : .primary)
                        }
                    }
                }
            }
            
            Divider()
            
            // Modular subview passing @Binding to demonstrate state delegation
            IntakeAmountAdjuster(
                intakeAmount: $currentIntakeAmount,
                unitSymbol: healthModel.preferredUnit.symbol
            )
            
            Divider()
            
            // DatePicker to select the date of the record
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("Log Date & Time", systemImage: "calendar")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                }
                
                DatePicker(
                    "Select Date",
                    selection: $recordDate,
                    in: ...Date(),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .labelsHidden()
            }
            
            // Optional Note Field
            HStack {
                Image(systemName: "pencil")
                    .foregroundColor(.secondary)
                TextField("Add a note (e.g. Post-lunch)", text: $optionalNote)
                    .font(.subheadline)
            }
            .padding(10)
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // Main Button to add the record to the model
            Button {
                saveRecord()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add \(Int(currentIntakeAmount)) ml to Tracker")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
    
    // MARK: - Quick Presets
    private var quickPresetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("One-Tap Quick Log")
                .font(.headline)
            
            HStack(spacing: 12) {
                QuickPresetCard(amount: 250, label: "Glass", icon: "cup.and.saucer.fill", color: .cyan) {
                    quickLog(amount: 250, type: .glass)
                }
                QuickPresetCard(amount: 500, label: "Bottle", icon: "waterbottle.fill", color: .blue) {
                    quickLog(amount: 500, type: .bottle)
                }
                QuickPresetCard(amount: 750, label: "Flask", icon: "figure.run.circle.fill", color: .indigo) {
                    quickLog(amount: 750, type: .sportsBottle)
                }
            }
        }
    }
    
    // MARK: - Actions
    private func saveRecord() {
        healthModel.addWaterRecord(
            amount: currentIntakeAmount,
            date: recordDate,
            containerType: selectedContainer,
            note: optionalNote.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        lastLoggedAmount = currentIntakeAmount
        optionalNote = ""
        
        withAnimation {
            showSuccessBanner = true
        }
        
        // Auto-hide banner after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showSuccessBanner = false
            }
        }
    }
    
    private func quickLog(amount: Double, type: WaterRecord.ContainerType) {
        healthModel.quickAddWater(amount: amount, type: type)
        lastLoggedAmount = amount
        withAnimation {
            showSuccessBanner = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showSuccessBanner = false
            }
        }
    }
}

// MARK: - Modular Subview using @Binding for Intake Stepper
struct IntakeAmountAdjuster: View {
    @Binding var intakeAmount: Double
    let unitSymbol: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Intake Amount")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Use stepper to adjust by 50 ml")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(Int(intakeAmount)) \(unitSymbol)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            // Stepper component
            Stepper("", value: $intakeAmount, in: 50...2500, step: 50)
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// MARK: - Quick Preset Card
struct QuickPresetCard: View {
    let amount: Int
    let label: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
                
                Text("+\(amount) ml")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    WaterTrackerView(healthModel: HealthModel())
}
