//
//  DashboardView.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// Main Home / Dashboard View featuring the Daily Health Summary and interactive hydration metrics
struct DashboardView: View {
    @ObservedObject var healthModel: HealthModel
    @Binding var selectedTab: Int
    
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Greeting
                    headerSection
                    
                    // Daily Hydration Summary Card with ProgressView
                    hydrationSummaryCard
                    
                    // Quick Metric Grid
                    metricsGridSection
                    
                    // Quick Action Presets
                    quickAddSection
                    
                    // BMI Overview Card
                    bmiOverviewCard
                    
                    // Recent Activity Mini-List
                    recentActivitySection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddWaterRecordSheet(healthModel: healthModel, isPresented: $showingAddSheet)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, \(healthModel.userName) 👋")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(Date().formatted(date: .complete, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            // Hydration streak / status chip
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("Day 4")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.orange.opacity(0.12))
            .clipShape(Capsule())
        }
        .padding(.top, 10)
    }
    
    // MARK: - Hydration Summary Card (Contains ProgressView)
    private var hydrationSummaryCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("DAILY HYDRATION")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .tracking(1)
                    
                    Text("Today's Hydration Progress")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Spacer()
                
                Text("\(healthModel.todayProgressPercentage)%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(healthModel.todayProgressPercentage >= 100 ? .green : .blue)
            }
            
            // Circular Ring
            CircularHydrationProgressView(
                progressRatio: healthModel.todayProgressRatio,
                currentAmount: healthModel.todayWaterIntake,
                goalAmount: healthModel.dailyWaterGoal,
                unitSymbol: healthModel.preferredUnit.symbol
            )
            
            // Linear ProgressView (Directly fulfilling required UI Component)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Daily Target Progress")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(healthModel.todayWaterIntake)) / \(Int(healthModel.dailyWaterGoal)) \(healthModel.preferredUnit.symbol)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                // SwiftUI native ProgressView
                ProgressView(value: healthModel.todayProgressRatio)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                    .scaleEffect(x: 1, y: 2.2, anchor: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.top, 4)
            
            // Motivational status text
            HStack {
                Image(systemName: healthModel.todayProgressPercentage >= 100 ? "star.fill" : "info.circle.fill")
                    .foregroundColor(healthModel.todayProgressPercentage >= 100 ? .green : .blue)
                
                Text(motivationalMessage)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    // MARK: - Metrics Grid
    private var metricsGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            MetricCardView(
                title: "Intake",
                value: healthModel.formattedAmount(healthModel.todayWaterIntake),
                subtitle: "\(healthModel.todayGlassesCount) glasses",
                iconName: "drop.fill",
                accentColor: .blue
            )
            
            MetricCardView(
                title: "Remaining",
                value: healthModel.formattedAmount(healthModel.remainingWaterForToday),
                subtitle: healthModel.remainingWaterForToday == 0 ? "Goal achieved!" : "To reach goal",
                iconName: "flag.checkered",
                accentColor: healthModel.remainingWaterForToday == 0 ? .green : .orange
            )
            
            MetricCardView(
                title: "Daily Target",
                value: healthModel.formattedAmount(healthModel.dailyWaterGoal),
                subtitle: "Configured target",
                iconName: "target",
                accentColor: .purple
            )
            
            MetricCardView(
                title: "BMI Score",
                value: String(format: "%.1f", healthModel.bmi),
                subtitle: healthModel.bmiCategory.rawValue,
                iconName: "scalemass.fill",
                accentColor: healthModel.bmiCategory.color
            )
        }
    }
    
    // MARK: - Quick Add Section
    private var quickAddSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Quick Add")
                    .font(.headline)
                Spacer()
                Text("Tap to record")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                QuickAddButton(title: "+250 ml", icon: "cup.and.saucer.fill", color: .cyan) {
                    healthModel.quickAddWater(amount: 250, type: .glass)
                }
                
                QuickAddButton(title: "+500 ml", icon: "waterbottle.fill", color: .blue) {
                    healthModel.quickAddWater(amount: 500, type: .bottle)
                }
                
                QuickAddButton(title: "+750 ml", icon: "figure.run.circle.fill", color: .indigo) {
                    healthModel.quickAddWater(amount: 750, type: .sportsBottle)
                }
            }
        }
    }
    
    // MARK: - BMI Overview Card
    private var bmiOverviewCard: some View {
        Button {
            selectedTab = 1 // Navigate to BMI Calculator tab
        } label: {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Body Mass Index")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Text("BMI: \(String(format: "%.1f", healthModel.bmi)) • \(healthModel.bmiCategory.rawValue)")
                        .font(.headline)
                        .foregroundColor(healthModel.bmiCategory.color)
                    
                    Text("Height: \(Int(healthModel.userHeightCm)) cm | Weight: \(String(format: "%.1f", healthModel.userWeightKg)) kg")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Activity")
                    .font(.headline)
                Spacer()
                Button("View All") {
                    selectedTab = 3 // Navigate to History tab
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            let todaysRecords = healthModel.waterRecords
                .filter { Calendar.current.isDateInToday($0.date) }
                .prefix(3)
            
            if todaysRecords.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "drop")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No hydration entries recorded today yet.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(Array(todaysRecords)) { record in
                        HStack(spacing: 14) {
                            Image(systemName: record.containerType.iconName)
                                .font(.system(size: 18))
                                .foregroundColor(.blue)
                                .frame(width: 38, height: 38)
                                .background(Color.blue.opacity(0.12))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(record.note.isEmpty ? record.containerType.rawValue : record.note)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(record.date.formatted(date: .omitted, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("+\(healthModel.formattedAmount(record.amountInMl))")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.secondarySystemGroupedBackground))
                        )
                    }
                }
            }
        }
    }
    
    private var motivationalMessage: String {
        let percent = healthModel.todayProgressPercentage
        if percent >= 100 {
            return "Fantastic! You have achieved your daily hydration goal! 🎉"
        } else if percent >= 75 {
            return "Almost there! Just a couple of glasses left to reach your goal."
        } else if percent >= 50 {
            return "Halfway through! Keep sipping consistently throughout the day."
        } else if percent >= 25 {
            return "Good start! Don't forget to keep a water bottle nearby."
        } else {
            return "Start your day with a fresh glass of water to power your focus!"
        }
    }
}

// MARK: - Quick Add Button Component
struct QuickAddButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DashboardView(healthModel: HealthModel(), selectedTab: .constant(0))
}
