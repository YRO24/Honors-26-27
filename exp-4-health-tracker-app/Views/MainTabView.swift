//
//  MainTabView.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// Root TabView providing bottom navigation across the five application modules
struct MainTabView: View {
    @ObservedObject var healthModel: HealthModel
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 1. Home / Dashboard
            DashboardView(healthModel: healthModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            // 2. BMI Calculator
            BMICalculatorView(healthModel: healthModel)
                .tabItem {
                    Label("BMI", systemImage: "scalemass.fill")
                }
                .tag(1)
            
            // 3. Water Consumption Tracking
            WaterTrackerView(healthModel: healthModel)
                .tabItem {
                    Label("Hydration", systemImage: "drop.fill")
                }
                .tag(2)
            
            // 4. Water History
            WaterHistoryView(healthModel: healthModel)
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(3)
            
            // 5. Settings
            SettingsView(healthModel: healthModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView(healthModel: HealthModel())
}
