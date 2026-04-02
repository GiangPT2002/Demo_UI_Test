//
//  TaskItem.swift
//  Demo_UI_Test
//

import Foundation

/// Represents a single task in the task manager.
struct TaskItem: Identifiable, Equatable, Codable {
    var id: String?
    var user_id: String
    var title: String
    var taskDescription: String
    var priority: TaskPriority
    var isCompleted: Bool
    let createdAt: Date
    var dueDate: Date?

    init(
        id: String? = nil,
        user_id: String = "",
        title: String,
        taskDescription: String = "",
        priority: TaskPriority = .medium,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        dueDate: Date? = nil
    ) {
        self.id = id
        self.user_id = user_id
        self.title = title
        self.taskDescription = taskDescription
        self.priority = priority
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
    }

    /// Whether the task has a due date that has passed
    var isOverdue: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        return dueDate < Date()
    }

    /// Whether the task has a non-empty description
    var hasDescription: Bool {
        !taskDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
