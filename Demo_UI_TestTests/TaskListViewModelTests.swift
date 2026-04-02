//
//  TaskListViewModelTests.swift
//  Demo_UI_TestTests
//

import Foundation
import Testing
@testable import Demo_UI_Test

struct TaskListViewModelTests {

    // MARK: - Helper

    private func makeViewModel() -> TaskListViewModel {
        TaskListViewModel()
    }

    private func sampleTask(
        title: String = "Test",
        priority: TaskPriority = .medium,
        isCompleted: Bool = false
    ) -> TaskItem {
        TaskItem(id: UUID().uuidString, title: title, priority: priority, isCompleted: isCompleted)
    }

    // MARK: - Add Task

    @Test func testAddTask_insertsAtBeginning() {
        let vm = makeViewModel()
        let task1 = sampleTask(title: "First")
        let task2 = sampleTask(title: "Second")

        vm.addTask(task1)
        vm.addTask(task2)

        #expect(vm.tasks.count == 2)
        #expect(vm.tasks.first?.title == "Second")
    }

    // MARK: - Delete Task

    @Test func testDeleteTask_byId() {
        let vm = makeViewModel()
        let task = sampleTask(title: "To Delete")
        vm.addTask(task)

        if let id = task.id {
            vm.deleteTask(id: id)
        }

        #expect(vm.tasks.isEmpty)
    }

    @Test func testDeleteTask_nonExistentId_doesNothing() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "Keep"))

        vm.deleteTask(id: UUID().uuidString)

        #expect(vm.tasks.count == 1)
    }

    // MARK: - Toggle Complete

    @Test func testToggleComplete() {
        let vm = makeViewModel()
        let task = sampleTask(title: "Toggle Me")
        vm.addTask(task)

        #expect(vm.tasks[0].isCompleted == false)

        if let id = task.id {
            vm.toggleComplete(id: id)
            #expect(vm.tasks[0].isCompleted == true)

            vm.toggleComplete(id: id)
            #expect(vm.tasks[0].isCompleted == false)
        }
    }

    // MARK: - Delete All

    @Test func testDeleteAll() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "A"))
        vm.addTask(sampleTask(title: "B"))
        vm.addTask(sampleTask(title: "C"))

        vm.deleteAll()

        #expect(vm.tasks.isEmpty)
    }

    // MARK: - Filtering

    @Test func testFilteredTasks_noFilter_returnsAll() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "A", priority: .low))
        vm.addTask(sampleTask(title: "B", priority: .high))

        #expect(vm.filteredTasks.count == 2)
    }

    @Test func testFilteredTasks_withPriorityFilter() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "Low", priority: .low))
        vm.addTask(sampleTask(title: "High", priority: .high))
        vm.addTask(sampleTask(title: "High2", priority: .high))

        vm.selectedFilter = .high

        #expect(vm.filteredTasks.count == 2)
        #expect(vm.filteredTasks.allSatisfy { $0.priority == .high })
    }

    @Test func testFilteredTasks_withSearchText() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "Buy groceries"))
        vm.addTask(sampleTask(title: "Write code"))
        vm.addTask(sampleTask(title: "Review pull request"))

        vm.searchText = "code"

        #expect(vm.filteredTasks.count == 1)
        #expect(vm.filteredTasks.first?.title == "Write code")
    }

    @Test func testFilteredTasks_searchIsCaseInsensitive() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "Deploy Server"))

        vm.searchText = "DEPLOY"

        #expect(vm.filteredTasks.count == 1)
    }

    @Test func testFilteredTasks_combinedSearchAndFilter() {
        let vm = makeViewModel()
        vm.addTask(TaskItem(title: "High priority bug", priority: .high))
        vm.addTask(TaskItem(title: "Low priority bug", priority: .low))
        vm.addTask(TaskItem(title: "High priority feature", priority: .high))

        vm.selectedFilter = .high
        vm.searchText = "bug"

        #expect(vm.filteredTasks.count == 1)
        #expect(vm.filteredTasks.first?.title == "High priority bug")
    }

    // MARK: - Computed Counts

    @Test func testCompletedCount() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "Done", isCompleted: true))
        vm.addTask(sampleTask(title: "Done2", isCompleted: true))
        vm.addTask(sampleTask(title: "Pending"))

        #expect(vm.completedCount == 2)
    }

    @Test func testPendingCount() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "Done", isCompleted: true))
        vm.addTask(sampleTask(title: "Pending1"))
        vm.addTask(sampleTask(title: "Pending2"))

        #expect(vm.pendingCount == 2)
    }

    @Test func testTotalCount() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "A"))
        vm.addTask(sampleTask(title: "B"))

        #expect(vm.totalCount == 2)
    }

    @Test func testCompletionProgress_empty_returnsZero() {
        let vm = makeViewModel()
        #expect(vm.completionProgress == 0)
    }

    @Test func testCompletionProgress_allDone_returnsOne() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "A", isCompleted: true))
        vm.addTask(sampleTask(title: "B", isCompleted: true))

        #expect(vm.completionProgress == 1.0)
    }

    @Test func testCompletionProgress_halfDone() {
        let vm = makeViewModel()
        vm.addTask(sampleTask(title: "Done", isCompleted: true))
        vm.addTask(sampleTask(title: "Pending"))

        #expect(vm.completionProgress == 0.5)
    }

    // MARK: - Clear Filters

    @Test func testClearFilters() {
        let vm = makeViewModel()
        vm.searchText = "something"
        vm.selectedFilter = .high

        vm.clearFilters()

        #expect(vm.searchText.isEmpty)
        #expect(vm.selectedFilter == nil)
    }

    // MARK: - Sample Data

    @Test func testLoadSampleData() {
        let vm = makeViewModel()
        vm.loadSampleData()

        #expect(vm.tasks.count == 5)
    }
}
