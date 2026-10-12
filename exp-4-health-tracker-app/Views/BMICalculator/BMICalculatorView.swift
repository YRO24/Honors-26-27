//
//  BMICalculatorView.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// BMI Calculator view allowing users to input height and weight, calculate BMI, and view health insights
struct BMICalculatorView: View {
    @ObservedObject var healthModel: HealthModel
    
    // Local editable state for interactive calculations
    @State private var heightCm: Double = 175.0
    @State private var weightKg: Double = 68.5
    @State private var unitSystem: UnitSystem = .metric
    
    // Imperial helper state
    @State private var heightFeet: Int = 5
    @State private var heightInches: Int = 9
    @State private var weightLbs: Double = 151.0
    
    @State private var showSavedAlert: Bool = false
    
    enum UnitSystem: String, CaseIterable {
        case metric = "Metric (cm/kg)"
        case imperial = "Imperial (ft/lbs)"
    }
    
    // Computed BMI from current input state
    private var currentBMI: Double {
        let hMeters = heightCm / 100.0
        guard hMeters > 0 else { return 0.0 }
        return weightKg / (hMeters * hMeters)
    }
    
    private var currentCategory: BMICategory {
        BMICategory.category(for: currentBMI)
    }
    
    private var healthyWeightRangeString: String {
        let hMeters = heightCm / 100.0
        let minW = 18.5 * (hMeters * hMeters)
        let maxW = 24.9 * (hMeters * hMeters)
        if unitSystem == .metric {
            return String(format: "%.1f kg - %.1f kg", minW, maxW)
        } else {
            let minLbs = minW * 2.20462
            let maxLbs = maxW * 2.20462
            return String(format: "%.1f lbs - %.1f lbs", minLbs, maxLbs)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Unit System Picker
                    Picker("Unit System", selection: $unitSystem) {
                        ForEach(UnitSystem.allCases, id: \.self) { system in
                            Text(system.rawValue).tag(system)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 8)
                    .onChange(of: unitSystem) { newSystem in
                        syncUnits(to: newSystem)
                    }
                    
                    // BMI Result Card
                    bmiResultCard
                    
                    // Input Controls (Height & Weight)
                    inputControlsCard
                    
                    // Action Buttons (Save to Health Profile & Reset)
                    actionButtonsSection
                    
                    // Categories Reference Card
                    categoriesReferenceSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("BMI Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Initialize local state from model
                self.heightCm = healthModel.userHeightCm
                self.weightKg = healthModel.userWeightKg
                updateImperialFromMetric()
            }
            .alert("Profile Updated", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your height and weight have been saved to your health profile.")
            }
        }
    }
    
    // MARK: - BMI Result Card
    private var bmiResultCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("YOUR RESULT")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .tracking(1)
                    
                    Text(currentCategory.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(currentCategory.color)
                }
                
                Spacer()
                
                Image(systemName: currentCategory.iconName)
                    .font(.system(size: 32))
                    .foregroundColor(currentCategory.color)
            }
            
            // Large BMI Number
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(String(format: "%.1f", currentBMI))
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("BMI")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            // Visual BMI Gauge Bar
            bmiGaugeBar
            
            // Healthy weight info
            HStack {
                Label("Ideal Weight:", systemImage: "heart.text.square")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(healthyWeightRangeString)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .clipShape(Capsule())
            
            // Advice note
            Text(currentCategory.advice)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
    
    // MARK: - Visual BMI Gauge Bar
    private var bmiGaugeBar: some View {
        VStack(spacing: 6) {
            GeometryReader { geometry in
                let width = geometry.size.width
                // Calculate cursor position clamped between 15 and 35
                let normalized = min(max((currentBMI - 15.0) / 20.0, 0.0), 1.0)
                let pointerX = width * normalized
                
                ZStack(alignment: .leading) {
                    // 4 Colored Segments
                    HStack(spacing: 3) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.blue)
                            .frame(width: width * 0.175) // < 18.5
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.green)
                            .frame(width: width * 0.32)  // 18.5 - 24.9
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.orange)
                            .frame(width: width * 0.25)  // 25 - 29.9
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.red) // >= 30
                    }
                    .frame(height: 10)
                    
                    // Pointer Indicator
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .offset(x: max(0, min(pointerX - 7, width - 14)), y: -14)
                }
            }
            .frame(height: 20)
            
            HStack {
                Text("15")
                Spacer()
                Text("18.5")
                Spacer()
                Text("25")
                Spacer()
                Text("30")
                Spacer()
                Text("35+")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Input Controls Card
    private var inputControlsCard: some View {
        VStack(spacing: 20) {
            if unitSystem == .metric {
                // Height in cm
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Height", systemImage: "ruler")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(heightCm)) cm")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    Slider(value: $heightCm, in: 100...220, step: 1)
                        .tint(.blue)
                    
                    HStack {
                        Text("100 cm")
                        Spacer()
                        Stepper("", value: $heightCm, in: 100...220, step: 1)
                            .labelsHidden()
                        Spacer()
                        Text("220 cm")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Weight in kg
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Weight", systemImage: "scalemass")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.1f kg", weightKg))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    Slider(value: $weightKg, in: 30...160, step: 0.5)
                        .tint(.blue)
                    
                    HStack {
                        Text("30 kg")
                        Spacer()
                        Stepper("", value: $weightKg, in: 30...160, step: 0.5)
                            .labelsHidden()
                        Spacer()
                        Text("160 kg")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            } else {
                // Imperial: Feet and Inches
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("Height", systemImage: "ruler")
                            .font(.headline)
                        Spacer()
                        Text("\(heightFeet) ft \(heightInches) in")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 16) {
                        Picker("Feet", selection: $heightFeet) {
                            ForEach(3...7, id: \.self) { ft in
                                Text("\(ft) ft").tag(ft)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 90)
                        .clipped()
                        
                        Picker("Inches", selection: $heightInches) {
                            ForEach(0...11, id: \.self) { inch in
                                Text("\(inch) in").tag(inch)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 90)
                        .clipped()
                    }
                    .onChange(of: heightFeet) { _ in updateMetricFromImperial() }
                    .onChange(of: heightInches) { _ in updateMetricFromImperial() }
                }
                
                Divider()
                
                // Weight in lbs
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Weight", systemImage: "scalemass")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.1f lbs", weightLbs))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    Slider(value: $weightLbs, in: 66...350, step: 1)
                        .tint(.blue)
                        .onChange(of: weightLbs) { _ in updateMetricFromImperial() }
                    
                    HStack {
                        Text("66 lbs")
                        Spacer()
                        Stepper("", value: $weightLbs, in: 66...350, step: 1)
                            .labelsHidden()
                            .onChange(of: weightLbs) { _ in updateMetricFromImperial() }
                        Spacer()
                        Text("350 lbs")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
    
    // MARK: - Action Buttons
    private var actionButtonsSection: some View {
        VStack(spacing: 10) {
            Button {
                healthModel.updateMetrics(heightCm: heightCm, weightKg: weightKg)
                showSavedAlert = true
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Save to Health Profile")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            
            Button {
                heightCm = 175.0
                weightKg = 68.5
                updateImperialFromMetric()
            } label: {
                Text("Reset to Defaults")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Categories Reference
    private var categoriesReferenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BMI Classification")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(BMICategory.allCases, id: \.self) { cat in
                    HStack {
                        Circle()
                            .fill(cat.color)
                            .frame(width: 10, height: 10)
                        
                        Text(cat.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(cat.rangeDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(currentCategory == cat ? cat.color.opacity(0.12) : Color(UIColor.secondarySystemGroupedBackground))
                    )
                }
            }
        }
    }
    
    // MARK: - Conversion Helpers
    private func updateImperialFromMetric() {
        let totalInches = heightCm / 2.54
        heightFeet = Int(totalInches / 12)
        heightInches = Int(totalInches.truncatingRemainder(dividingBy: 12))
        weightLbs = weightKg * 2.20462
    }
    
    private func updateMetricFromImperial() {
        let totalInches = Double(heightFeet * 12 + heightInches)
        heightCm = totalInches * 2.54
        weightKg = weightLbs / 2.20462
    }
    
    private func syncUnits(to system: UnitSystem) {
        if system == .imperial {
            updateImperialFromMetric()
        } else {
            updateMetricFromImperial()
        }
    }
}

#Preview {
    BMICalculatorView(healthModel: HealthModel())
}
