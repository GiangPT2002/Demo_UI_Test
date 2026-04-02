//
//  TaskRowView.swift
//  Demo_UI_Test
//

import SwiftUI

/// A single row in the task list, displaying task info with checkbox.
struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? .completedGreen : .textSecondary)
                    .animation(.spring(response: 0.3), value: task.isCompleted)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("toggleButton_\(task.title)")

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .strikethrough(task.isCompleted, color: .textSecondary)
                    .foregroundColor(task.isCompleted ? .textSecondary : .primary)
                    .lineLimit(1)
                    .accessibilityIdentifier("taskTitle_\(task.title)")

                HStack(spacing: 8) {
                    PriorityBadge(priority: task.priority)

                    if let dueDate = task.dueDate {
                        HStack(spacing: 3) {
                            Image(systemName: "calendar")
                                .font(.caption2)
                            Text(dueDate.relativeFormatted)
                                .font(.caption)
                        }
                        .foregroundColor(task.isOverdue ? .overdueRed : .textSecondary)
                        .accessibilityIdentifier("dueDate_\(task.title)")
                    }
                }
            }

            Spacer()

            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textSecondary.opacity(0.5))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        .accessibilityIdentifier("taskRow_\(task.title)")
    }
}

#Preview {
    VStack(spacing: 12) {
        TaskRowView(
            task: TaskItem(title: "Complete project", priority: .high, dueDate: Date()),
            onToggle: {}
        )
        TaskRowView(
            task: TaskItem(title: "Done task", priority: .low, isCompleted: true),
            onToggle: {}
        )
    }
    .padding()
    .background(Color.appBackground)
}
