//
//  TaskFormViewModel.swift
//  Demo_UI_Test
//

import Foundation
import Observation

/// ViewModel for the add/edit task form.
@Observable
final class TaskFormViewModel {

    // MARK: - Form State

    /// Task title input
    var title: String = ""

    /// Task description input
    var taskDescription: String = ""

    /// Selected priority
    var priority: TaskPriority = .medium

    /// Whether a due date is set
    var hasDueDate: Bool = false

    /// The selected due date
    var dueDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()

    // MARK: - Validation

    /// Whether the form is valid (title is not empty after trimming)
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Validation error message (if any)
    var titleError: String? {
        if title.isEmpty { return nil } // Don't show error before user starts typing
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Title cannot be blank"
        }
        return nil
    }

    // MARK: - Actions

    /// Create a TaskItem from the current form state
    func createTask() -> TaskItem {
        TaskItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            taskDescription: taskDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            priority: priority,
            dueDate: hasDueDate ? dueDate : nil
        )
    }

    /// Reset all form fields to defaults
    func reset() {
        title = ""
        taskDescription = ""
        priority = .medium
        hasDueDate = false
        dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
}
