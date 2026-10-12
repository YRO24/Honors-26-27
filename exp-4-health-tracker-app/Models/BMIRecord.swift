//
//  BMIRecord.swift
//  exp-4-health-tracker-app
//

import Foundation
import SwiftUI

/// BMI category classifications with recommendations and theme colors
enum BMICategory: String, CaseIterable {
    case underweight = "Underweight"
    case normal = "Normal Weight"
    case overweight = "Overweight"
    case obese = "Obese"
    
    var rangeDescription: String {
        switch self {
        case .underweight: return "< 18.5"
        case .normal: return "18.5 - 24.9"
        case .overweight: return "25.0 - 29.9"
        case .obese: return "≥ 30.0"
        }
    }
    
    var color: Color {
        switch self {
        case .underweight: return .blue
        case .normal: return .green
        case .overweight: return .orange
        case .obese: return .red
        }
    }
    
    var iconName: String {
        switch self {
        case .underweight: return "arrow.down.circle.fill"
        case .normal: return "checkmark.circle.fill"
        case .overweight: return "exclamationmark.triangle.fill"
        case .obese: return "exclamationmark.circle.fill"
        }
    }
    
    var advice: String {
        switch self {
        case .underweight:
            return "Consider nutrient-rich foods and strength training to build healthy mass."
        case .normal:
            return "Great job! Keep maintaining a balanced diet and regular physical activity."
        case .overweight:
            return "A combination of aerobic exercise and portion control can help reach your ideal weight."
        case .obese:
            return "Consult a healthcare professional for a tailored nutrition and fitness plan."
        }
    }
    
    static func category(for bmi: Double) -> BMICategory {
        switch bmi {
        case ..<18.5:
            return .underweight
        case 18.5..<25.0:
            return .normal
        case 25.0..<30.0:
            return .overweight
        default:
            return .obese
        }
    }
}
