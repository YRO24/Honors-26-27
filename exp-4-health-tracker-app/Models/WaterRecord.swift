//
//  WaterRecord.swift
//  exp-4-health-tracker-app
//

import Foundation
import SwiftUI

/// Represents a single water intake entry
struct WaterRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var amountInMl: Double
    var date: Date
    var note: String
    var containerType: ContainerType
    
    enum ContainerType: String, CaseIterable, Codable {
        case glass = "Glass"
        case bottle = "Bottle"
        case mug = "Mug"
        case sportsBottle = "Flask"
        case custom = "Custom"
        
        var iconName: String {
            switch self {
            case .glass: return "cup.and.saucer.fill"
            case .bottle: return "waterbottle.fill"
            case .mug: return "mug.fill"
            case .sportsBottle: return "figure.run.circle.fill"
            case .custom: return "drop.fill"
            }
        }
        
        var defaultAmountMl: Double {
            switch self {
            case .glass: return 250.0
            case .bottle: return 500.0
            case .mug: return 350.0
            case .sportsBottle: return 750.0
            case .custom: return 200.0
            }
        }
    }
}
