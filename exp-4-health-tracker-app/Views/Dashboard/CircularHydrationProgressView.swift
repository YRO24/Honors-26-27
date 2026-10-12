//
//  CircularHydrationProgressView.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// Animated circular hydration ring with center statistics
struct CircularHydrationProgressView: View {
    let progressRatio: Double
    let currentAmount: Double
    let goalAmount: Double
    let unitSymbol: String
    
    @State private var animatedProgress: Double = 0.0
    
    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(
                    Color.cyan.opacity(0.15),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
            
            // Progress arc
            Circle()
                .trim(from: 0.0, to: min(animatedProgress, 1.0))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.blue,
                            Color.cyan,
                            Color.teal,
                            Color.blue
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: animatedProgress)
            
            // Center metrics
            VStack(spacing: 6) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("\(Int(progressRatio * 100))%")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("\(Int(currentAmount)) / \(Int(goalAmount)) \(unitSymbol)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 220, height: 220)
        .padding()
        .onAppear {
            animatedProgress = progressRatio
        }
        .onChange(of: progressRatio) { newValue in
            animatedProgress = newValue
        }
    }
}

#Preview {
    CircularHydrationProgressView(
        progressRatio: 0.65,
        currentAmount: 1625,
        goalAmount: 2500,
        unitSymbol: "ml"
    )
}
