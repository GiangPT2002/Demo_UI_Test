//
//  PriorityBadge.swift
//  Demo_UI_Test
//

import SwiftUI

/// A capsule-shaped badge that displays a task's priority level.
struct PriorityBadge: View {
    let priority: TaskPriority

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: priority.iconName)
                .font(.caption2)

            Text(priority.displayName)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(priority.color.opacity(0.15))
        .foregroundColor(priority.color)
        .clipShape(Capsule())
        .accessibilityIdentifier("priorityBadge_\(priority.rawValue)")
    }
}

#Preview {
    HStack(spacing: 12) {
        PriorityBadge(priority: .low)
        PriorityBadge(priority: .medium)
        PriorityBadge(priority: .high)
    }
    .padding()
}
