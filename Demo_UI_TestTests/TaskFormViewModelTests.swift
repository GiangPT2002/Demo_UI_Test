//
//  TaskFormViewModelTests.swift
//  Demo_UI_TestTests
//

import Testing
@testable import Demo_UI_Test

struct TaskFormViewModelTests {

    // MARK: - Helper

    private func makeViewModel() -> TaskFormViewModel {
        TaskFormViewModel()
    }

    // MARK: - Default Values

    @Test func testDefaultState() {
        let vm = makeViewModel()

        #expect(vm.title.isEmpty)
        #expect(vm.taskDescription.isEmpty)
        #expect(vm.priority == .medium)
        #expect(vm.hasDueDate == false)
        #expect(vm.isValid == false)
    }

    // MARK: - Validation

    @Test func testIsValid_emptyTitle_returnsFalse() {
        let vm = makeViewModel()
        vm.title = ""
        #expect(vm.isValid == false)
    }

    @Test func testIsValid_whitespaceOnlyTitle_returnsFalse() {
        let vm = makeViewModel()
        vm.title = "   \t\n  "
        #expect(vm.isValid == false)
    }

    @Test func testIsValid_validTitle_returnsTrue() {
        let vm = makeViewModel()
        vm.title = "A real task"
        #expect(vm.isValid == true)
    }

    // MARK: - Title Error

    @Test func testTitleError_emptyTitle_noError() {
        let vm = makeViewModel()
        vm.title = ""
        #expect(vm.titleError == nil) // No error before user starts typing
    }

    @Test func testTitleError_whitespaceTitle_showsError() {
        let vm = makeViewModel()
        vm.title = "   "
        #expect(vm.titleError != nil)
    }

    @Test func testTitleError_validTitle_noError() {
        let vm = makeViewModel()
        vm.title = "Valid Title"
        #expect(vm.titleError == nil)
    }

    // MARK: - Create Task

    @Test func testCreateTask_withMinimalFields() {
        let vm = makeViewModel()
        vm.title = "  My Task  "

        let task = vm.createTask()

        #expect(task.title == "My Task") // Trimmed
        #expect(task.taskDescription.isEmpty)
        #expect(task.priority == .medium)
        #expect(task.dueDate == nil)
        #expect(task.isCompleted == false)
    }

    @Test func testCreateTask_withAllFields() {
        let vm = makeViewModel()
        vm.title = "Full Task"
        vm.taskDescription = "  Description here  "
        vm.priority = .high
        vm.hasDueDate = true
        let expectedDate = vm.dueDate

        let task = vm.createTask()

        #expect(task.title == "Full Task")
        #expect(task.taskDescription == "Description here")
        #expect(task.priority == .high)
        #expect(task.dueDate == expectedDate)
    }

    @Test func testCreateTask_withoutDueDate() {
        let vm = makeViewModel()
        vm.title = "No Due Date"
        vm.hasDueDate = false

        let task = vm.createTask()

        #expect(task.dueDate == nil)
    }

    // MARK: - Reset

    @Test func testReset_clearsAllFields() {
        let vm = makeViewModel()
        vm.title = "Something"
        vm.taskDescription = "Desc"
        vm.priority = .high
        vm.hasDueDate = true

        vm.reset()

        #expect(vm.title.isEmpty)
        #expect(vm.taskDescription.isEmpty)
        #expect(vm.priority == .medium)
        #expect(vm.hasDueDate == false)
    }
}
