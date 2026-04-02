//
//  Color+Theme.swift
//  Demo_UI_Test
//

import SwiftUI

extension Color {
    // MARK: - App Theme Colors

    /// Primary brand color
    static let appPrimary = Color(red: 0.35, green: 0.47, blue: 0.95)

    /// Secondary accent color
    static let appSecondary = Color(red: 0.56, green: 0.27, blue: 0.87)

    /// Background color for the app
    static let appBackground = Color(red: 0.96, green: 0.96, blue: 0.98)

    /// Card / surface background
    static let cardBackground = Color.white

    /// Subtle text color
    static let textSecondary = Color(red: 0.55, green: 0.55, blue: 0.60)

    // MARK: - Priority Colors

    /// Color for low priority tasks
    static let priorityLow = Color(red: 0.30, green: 0.78, blue: 0.47)

    /// Color for medium priority tasks
    static let priorityMedium = Color(red: 1.00, green: 0.72, blue: 0.20)

    /// Color for high priority tasks
    static let priorityHigh = Color(red: 0.96, green: 0.35, blue: 0.35)

    // MARK: - Status Colors

    /// Color for completed tasks
    static let completedGreen = Color(red: 0.22, green: 0.80, blue: 0.46)

    /// Color for overdue tasks
    static let overdueRed = Color(red: 0.93, green: 0.26, blue: 0.26)
}
