//
//  SettingsView.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// Health Settings view for configuring app preferences, user profile, and hydration goals
struct SettingsView: View {
    @ObservedObject var healthModel: HealthModel
    
    @State private var showingResetAlert: Bool = false
    @State private var showingClearAlert: Bool = false
    @State private var showingSavedToast: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Profile Section
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Name", text: $healthModel.userName)
                                .font(.headline)
                            Text("Health Profile")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        Label("Height", systemImage: "ruler")
                        Spacer()
                        Text("\(Int(healthModel.userHeightCm)) cm")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Weight", systemImage: "scalemass")
                        Spacer()
                        Text(String(format: "%.1f kg", healthModel.userWeightKg))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Current BMI", systemImage: "heart.text.square")
                        Spacer()
                        Text(String(format: "%.1f (%@)", healthModel.bmi, healthModel.bmiCategory.rawValue))
                            .foregroundColor(healthModel.bmiCategory.color)
                            .fontWeight(.medium)
                    }
                } header: {
                    Text("User Profile")
                } footer: {
                    Text("Height and weight can be adjusted in the BMI Calculator tab.")
                }
                
                // Hydration Goal Section
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Daily Water Goal")
                            Spacer()
                            Text(healthModel.formattedAmount(healthModel.dailyWaterGoal))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        Slider(value: $healthModel.dailyWaterGoal, in: 1000...4500, step: 100)
                            .tint(.blue)
                    }
                    .padding(.vertical, 4)
                    
                    Picker("Volume Unit", selection: $healthModel.preferredUnit) {
                        ForEach(WaterUnit.allCases) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                } header: {
                    Text("Hydration Preferences")
                }
                
                // Notifications & Alerts Section
                Section {
                    Toggle(isOn: $healthModel.remindersEnabled) {
                        Label("Drink Water Reminders", systemImage: "bell.badge.fill")
                    }
                    .tint(.blue)
                    
                    if healthModel.remindersEnabled {
                        Picker("Reminder Frequency", selection: $healthModel.reminderIntervalHours) {
                            Text("Every 1 hour").tag(1.0)
                            Text("Every 1.5 hours").tag(1.5)
                            Text("Every 2 hours").tag(2.0)
                            Text("Every 3 hours").tag(3.0)
                        }
                    }
                    
                    Toggle(isOn: $healthModel.hapticsEnabled) {
                        Label("Haptic Feedback", systemImage: "hand.tap.fill")
                    }
                    .tint(.blue)
                } header: {
                    Text("Notifications & Interactions")
                } footer: {
                    Text("Reminders help you build steady hydration habits throughout your workday.")
                }
                
                // Data Management Section
                Section {
                    Button {
                        showingResetAlert = true
                    } label: {
                        Label("Reload Sample Demo Data", systemImage: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
                    
                    Button(role: .destructive) {
                        showingClearAlert = true
                    } label: {
                        Label("Delete All Water Logs", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("Data Management")
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Application")
                        Spacer()
                        Text("Health & Hydration Tracker")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0 (Build 2026)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Architecture")
                        Spacer()
                        Text("SwiftUI • MVVM")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                } footer: {
                    Text("This app is intended for personal wellness tracking and does not substitute medical advice.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Reload Demo Records?", isPresented: $showingResetAlert) {
                Button("Reload", role: .none) {
                    healthModel.resetToDemoData()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will populate sample hydration entries across today and previous days for testing.")
            }
            .alert("Delete All Records?", isPresented: $showingClearAlert) {
                Button("Delete All", role: .destructive) {
                    healthModel.clearAllRecords()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to remove all logged water intake data? This cannot be undone.")
            }
        }
    }
}

#Preview {
    SettingsView(healthModel: HealthModel())
}
