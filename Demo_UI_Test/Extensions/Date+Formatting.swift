//
//  Date+Formatting.swift
//  Demo_UI_Test
//

import Foundation

extension Date {
    /// Short formatted date string (e.g. "Mar 30, 2026")
    var shortFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// Relative date string (e.g. "Today", "Tomorrow", "Mar 30")
    var relativeFormatted: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInTomorrow(self) {
            return "Tomorrow"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return shortFormatted
        }
    }

    /// Whether this date is before today (i.e. in the past)
    var isInThePast: Bool {
        return self < Date()
    }

    /// Number of days from today (negative = past, positive = future)
    var daysFromToday: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: self))
        return components.day ?? 0
    }
}
