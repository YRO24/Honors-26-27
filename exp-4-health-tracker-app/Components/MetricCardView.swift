//
//  MetricCardView.swift
//  exp-4-health-tracker-app
//

import SwiftUI

/// Reusable metric card component with iconography, accent colors, and modern layout
struct MetricCardView: View {
    let title: String
    let value: String
    let subtitle: String?
    let iconName: String
    let accentColor: Color
    
    init(
        title: String,
        value: String,
        subtitle: String? = nil,
        iconName: String,
        accentColor: Color = .blue
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.iconName = iconName
        self.accentColor = accentColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(accentColor)
                    .frame(width: 32, height: 32)
                    .background(accentColor.opacity(0.15))
                    .clipShape(Circle())
                
                Spacer()
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
    HStack {
        MetricCardView(
            title: "Today",
            value: "1,500 ml",
            subtitle: "60% of goal",
            iconName: "drop.fill",
            accentColor: .cyan
        )
        MetricCardView(
            title: "Remaining",
            value: "1,000 ml",
            subtitle: "4 glasses left",
            iconName: "flag.fill",
            accentColor: .orange
        )
    }
    .padding()
}
