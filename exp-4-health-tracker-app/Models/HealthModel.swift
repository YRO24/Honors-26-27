//
//  HealthModel.swift
//  exp-4-health-tracker-app
//

import Foundation
import SwiftUI
import Combine

/// Unit representation for liquid measurements
enum WaterUnit: String, CaseIterable, Identifiable {
    case ml = "Milliliters (ml)"
    case oz = "Fluid Ounces (fl oz)"
    
    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .ml: return "ml"
        case .oz: return "fl oz"
        }
    }
}

/// Central state model for health tracking, conforming to ObservableObject
final class HealthModel: ObservableObject {
    // MARK: - Published Properties
    
    /// Target daily water consumption goal in milliliters
    @Published var dailyWaterGoal: Double = 2500.0
    
    /// All recorded water intake events
    @Published var waterRecords: [WaterRecord] = []
    
    /// Height stored in centimeters
    @Published var userHeightCm: Double = 175.0
    
    /// Weight stored in kilograms
    @Published var userWeightKg: Double = 68.5
    
    /// User name for greeting
    @Published var userName: String = "Alex"
    
    /// Measurement unit preference
    @Published var preferredUnit: WaterUnit = .ml
    
    /// Reminder notifications toggle
    @Published var remindersEnabled: Bool = true
    
    /// Reminder interval in hours
    @Published var reminderIntervalHours: Double = 2.0
    
    /// Haptic feedback toggle
    @Published var hapticsEnabled: Bool = true
    
    // MARK: - Initializer
    init() {
        loadInitialDummyData()
    }
    
    // MARK: - Computed Properties for Hydration
    
    /// Water intake recorded specifically for today
    var todayWaterIntake: Double {
        let calendar = Calendar.current
        return waterRecords
            .filter { calendar.isDateInToday($0.date) }
            .reduce(0.0) { $0 + $1.amountInMl }
    }
    
    /// Hydration progress ratio between 0.0 and 1.0 (capped for ProgressView)
    var todayProgressRatio: Double {
        guard dailyWaterGoal > 0 else { return 0.0 }
        let ratio = todayWaterIntake / dailyWaterGoal
        return min(max(ratio, 0.0), 1.0)
    }
    
    /// Actual percentage progress (can exceed 100%)
    var todayProgressPercentage: Int {
        guard dailyWaterGoal > 0 else { return 0 }
        return Int((todayWaterIntake / dailyWaterGoal) * 100)
    }
    
    /// Remaining milliliters needed to reach today's goal
    var remainingWaterForToday: Double {
        max(dailyWaterGoal - todayWaterIntake, 0.0)
    }
    
    /// Number of glasses (250ml) consumed today
    var todayGlassesCount: Int {
        Int(todayWaterIntake / 250.0)
    }
    
    // MARK: - Computed Properties for BMI
    
    /// Computed BMI based on height and weight
    var bmi: Double {
        guard userHeightCm > 0 else { return 0.0 }
        let heightInMeters = userHeightCm / 100.0
        return userWeightKg / (heightInMeters * heightInMeters)
    }
    
    /// Category classification for current BMI
    var bmiCategory: BMICategory {
        BMICategory.category(for: bmi)
    }
    
    /// Healthy weight range for user's height (BMI 18.5 - 24.9)
    var healthyWeightRange: ClosedRange<Double> {
        let heightInMeters = userHeightCm / 100.0
        let minWeight = 18.5 * (heightInMeters * heightInMeters)
        let maxWeight = 24.9 * (heightInMeters * heightInMeters)
        return minWeight...maxWeight
    }
    
    // MARK: - Model Actions
    
    /// Adds a new water consumption record to the model
    func addWaterRecord(amount: Double, date: Date = Date(), containerType: WaterRecord.ContainerType = .custom, note: String = "") {
        let newRecord = WaterRecord(
            amountInMl: amount,
            date: date,
            note: note.isEmpty ? "\(containerType.rawValue)" : note,
            containerType: containerType
        )
        // Insert at beginning so history is sorted newest first
        waterRecords.insert(newRecord, at: 0)
        
        if hapticsEnabled {
            triggerHapticFeedback()
        }
    }
    
    /// Quick add helper for preset volumes
    func quickAddWater(amount: Double, type: WaterRecord.ContainerType) {
        addWaterRecord(amount: amount, date: Date(), containerType: type, note: "Quick Log (\(type.rawValue))")
    }
    
    /// Deletes records at specified offsets
    func deleteRecords(at offsets: IndexSet) {
        waterRecords.remove(atOffsets: offsets)
    }
    
    /// Deletes a specific record by id
    func deleteRecord(id: UUID) {
        waterRecords.removeAll { $0.id == id }
    }
    
    /// Updates user body metrics from BMI calculator
    func updateMetrics(heightCm: Double, weightKg: Double) {
        self.userHeightCm = heightCm
        self.userWeightKg = weightKg
    }
    
    /// Resets data to initial dummy demonstration records
    func resetToDemoData() {
        waterRecords.removeAll()
        loadInitialDummyData()
    }
    
    /// Clears all intake records
    func clearAllRecords() {
        waterRecords.removeAll()
    }
    
    // MARK: - Unit Conversion Helpers
    
    func formattedAmount(_ amountInMl: Double) -> String {
        switch preferredUnit {
        case .ml:
            return "\(Int(amountInMl)) ml"
        case .oz:
            let oz = amountInMl / 29.5735
            return String(format: "%.1f fl oz", oz)
        }
    }
    
    // MARK: - Dummy Data Generation
    
    private func loadInitialDummyData() {
        let calendar = Calendar.current
        let now = Date()
        
        var dummyList: [WaterRecord] = []
        
        // Today's records (e.g. 1500ml logged so far toward 2500ml goal)
        if let morning = calendar.date(bySettingHour: 8, minute: 15, second: 0, of: now) {
            dummyList.append(WaterRecord(
                amountInMl: 350.0,
                date: morning,
                note: "Morning hydration with lemon",
                containerType: .mug
            ))
        }
        if let midday = calendar.date(bySettingHour: 11, minute: 30, second: 0, of: now) {
            dummyList.append(WaterRecord(
                amountInMl: 500.0,
                date: midday,
                note: "Post-workout water bottle",
                containerType: .bottle
            ))
        }
        if let lunch = calendar.date(bySettingHour: 13, minute: 45, second: 0, of: now) {
            dummyList.append(WaterRecord(
                amountInMl: 250.0,
                date: lunch,
                note: "With lunch",
                containerType: .glass
            ))
        }
        if let afternoon = calendar.date(bySettingHour: 15, minute: 10, second: 0, of: now) {
            dummyList.append(WaterRecord(
                amountInMl: 400.0,
                date: afternoon,
                note: "Afternoon desk refresher",
                containerType: .sportsBottle
            ))
        }
        
        // Yesterday's records (Met goal: 2600ml)
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now) {
            if let y1 = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: yesterday) {
                dummyList.append(WaterRecord(amountInMl: 500.0, date: y1, note: "Morning start", containerType: .bottle))
            }
            if let y2 = calendar.date(bySettingHour: 12, minute: 30, second: 0, of: yesterday) {
                dummyList.append(WaterRecord(amountInMl: 600.0, date: y2, note: "Gym workout", containerType: .sportsBottle))
            }
            if let y3 = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: yesterday) {
                dummyList.append(WaterRecord(amountInMl: 750.0, date: y3, note: "Work hours flask", containerType: .bottle))
            }
            if let y4 = calendar.date(bySettingHour: 20, minute: 15, second: 0, of: yesterday) {
                dummyList.append(WaterRecord(amountInMl: 750.0, date: y4, note: "Evening dinner hydration", containerType: .sportsBottle))
            }
        }
        
        // 2 days ago (2250ml)
        if let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: now) {
            if let d1 = calendar.date(bySettingHour: 8, minute: 30, second: 0, of: twoDaysAgo) {
                dummyList.append(WaterRecord(amountInMl: 500.0, date: d1, note: "Breakfast tumbler", containerType: .bottle))
            }
            if let d2 = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: twoDaysAgo) {
                dummyList.append(WaterRecord(amountInMl: 750.0, date: d2, note: "Office refill", containerType: .sportsBottle))
            }
            if let d3 = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: twoDaysAgo) {
                dummyList.append(WaterRecord(amountInMl: 1000.0, date: d3, note: "Post tennis match", containerType: .sportsBottle))
            }
        }
        
        // 3 days ago (2500ml)
        if let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: now) {
            if let t1 = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: threeDaysAgo) {
                dummyList.append(WaterRecord(amountInMl: 500.0, date: t1, note: "Coffee break water", containerType: .bottle))
            }
            if let t2 = calendar.date(bySettingHour: 15, minute: 30, second: 0, of: threeDaysAgo) {
                dummyList.append(WaterRecord(amountInMl: 1000.0, date: t2, note: "Large jug refill", containerType: .sportsBottle))
            }
            if let t3 = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: threeDaysAgo) {
                dummyList.append(WaterRecord(amountInMl: 1000.0, date: t3, note: "Evening relaxation", containerType: .bottle))
            }
        }
        
        self.waterRecords = dummyList.sorted { $0.date > $1.date }
    }
    
    private func triggerHapticFeedback() {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        impact.impactOccurred()
        #endif
    }
}
