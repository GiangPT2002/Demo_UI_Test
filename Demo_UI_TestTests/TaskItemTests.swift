//
//  TaskItemTests.swift
//  Demo_UI_TestTests
//

import Foundation
import Testing
@testable import Demo_UI_Test

struct TaskItemTests {

    // MARK: - Initialization

    @Test func testDefaultInitialization() {
        let task = TaskItem(title: "Test Task")

        #expect(task.title == "Test Task")
        #expect(task.taskDescription.isEmpty)
        #expect(task.priority == .medium)
        #expect(task.isCompleted == false)
        #expect(task.dueDate == nil)
    }

    @Test func testCustomInitialization() {
        let dueDate = Date()
        let task = TaskItem(
            title: "Custom Task",
            taskDescription: "Some description",
            priority: .high,
            isCompleted: true,
            dueDate: dueDate
        )

        #expect(task.title == "Custom Task")
        #expect(task.taskDescription == "Some description")
        #expect(task.priority == .high)
        #expect(task.isCompleted == true)
        #expect(task.dueDate == dueDate)
    }

    // MARK: - Computed Properties

    @Test func testIsOverdue_noDueDate_returnsFalse() {
        let task = TaskItem(title: "No Due Date")
        #expect(task.isOverdue == false)
    }

    @Test func testIsOverdue_futureDueDate_returnsFalse() {
        let futureDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        let task = TaskItem(title: "Future Task", dueDate: futureDate)
        #expect(task.isOverdue == false)
    }

    @Test func testIsOverdue_pastDueDate_returnsTrue() {
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let task = TaskItem(title: "Overdue Task", dueDate: pastDate)
        #expect(task.isOverdue == true)
    }

    @Test func testIsOverdue_completedTask_returnsFalse() {
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let task = TaskItem(title: "Done Task", isCompleted: true, dueDate: pastDate)
        #expect(task.isOverdue == false)
    }

    @Test func testHasDescription_empty_returnsFalse() {
        let task = TaskItem(title: "No Desc")
        #expect(task.hasDescription == false)
    }

    @Test func testHasDescription_whitespaceOnly_returnsFalse() {
        let task = TaskItem(title: "Whitespace", taskDescription: "   \n  ")
        #expect(task.hasDescription == false)
    }

    @Test func testHasDescription_withContent_returnsTrue() {
        let task = TaskItem(title: "Has Desc", taskDescription: "Real description")
        #expect(task.hasDescription == true)
    }

    // MARK: - Equatable

    @Test func testEquality() {
        let id = UUID().uuidString
        let date = Date()
        let task1 = TaskItem(id: id, title: "Same", createdAt: date)
        let task2 = TaskItem(id: id, title: "Same", createdAt: date)
        #expect(task1 == task2)
    }

    @Test func testInequality() {
        let task1 = TaskItem(title: "Task A")
        let task2 = TaskItem(title: "Task B")
        #expect(task1 != task2)
    }
}
