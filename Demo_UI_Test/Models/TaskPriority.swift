//
//  TaskPriority.swift
//  Demo_UI_Test
//

import SwiftUI

/// Represents the priority level of a task.
enum TaskPriority: String, CaseIterable, Identifiable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }

    /// Display name for the priority
    var displayName: String { rawValue }

    /// Associated color for priority badge
    var color: Color {
        switch self {
        case .low:    return .priorityLow
        case .medium: return .priorityMedium
        case .high:   return .priorityHigh
        }
    }

    /// SF Symbol icon name
    var iconName: String {
        switch self {
        case .low:    return "arrow.down.circle.fill"
        case .medium: return "equal.circle.fill"
        case .high:   return "arrow.up.circle.fill"
        }
    }

    /// Sort order (higher priority = higher value)
    var sortOrder: Int {
        switch self {
        case .low:    return 0
        case .medium: return 1
        case .high:   return 2
        }
    }
}
