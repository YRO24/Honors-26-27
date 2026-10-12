//
//  AddWaterRecordSheet.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// Modal sheet for adding a new hydration record utilizing @State and @Binding
struct AddWaterRecordSheet: View {
    @ObservedObject var healthModel: HealthModel
    @Binding var isPresented: Bool
    
    // Local @State properties for user inputs
    @State private var intakeAmount: Double = 250.0
    @State private var recordDate: Date = Date()
    @State private var selectedContainer: WaterRecord.ContainerType = .glass
    @State private var customNote: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // Volume Section with Stepper
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Water Volume")
                                .font(.headline)
                            Spacer()
                            Text(healthModel.formattedAmount(intakeAmount))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        // Stepper for recording water intake amounts
                        Stepper(value: $intakeAmount, in: 50...2500, step: 50) {
                            Text("Adjust Amount (±50 ml)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Intake Amount")
                }
                
                // Container Type Picker
                Section {
                    Picker("Vessel", selection: $selectedContainer) {
                        ForEach(WaterRecord.ContainerType.allCases, id: \.self) { container in
                            Label(container.rawValue, systemImage: container.iconName)
                                .tag(container)
                        }
                    }
                    .onChange(of: selectedContainer) { newContainer in
                        intakeAmount = newContainer.defaultAmountMl
                    }
                } header: {
                    Text("Container Type")
                }
                
                // DatePicker for selecting the date and time of the record
                Section {
                    DatePicker(
                        "Date & Time",
                        selection: $recordDate,
                        in: ...Date(),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                } header: {
                    Text("Record Timestamp")
                }
                
                // Optional Note
                Section {
                    TextField("E.g., Morning workout hydration", text: $customNote)
                } header: {
                    Text("Note (Optional)")
                }
                
                // Add Record Button
                Section {
                    Button {
                        healthModel.addWaterRecord(
                            amount: intakeAmount,
                            date: recordDate,
                            containerType: selectedContainer,
                            note: customNote.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        isPresented = false
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                            Text("Log Water Intake")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Add Hydration Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    AddWaterRecordSheet(healthModel: HealthModel(), isPresented: .constant(true))
}
