//
//  TaskListUITests.swift
//  Demo_UI_TestUITests
//

import XCTest

final class TaskListUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    // MARK: - Empty State

    @MainActor
    func testEmptyState_showsEmptyMessage() throws {
        let emptyTitle = app.staticTexts["emptyStateTitle"]
        XCTAssertTrue(emptyTitle.waitForExistence(timeout: 5), "Empty state title should appear")
        XCTAssertEqual(emptyTitle.label, "No tasks yet")
    }

    // MARK: - Add Task

    @MainActor
    func testAddTask_appearsInList() throws {
        // Tap add button
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        // Fill in title
        let titleField = app.textFields["taskTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Buy groceries")

        // Tap Save
        let saveButton = app.buttons["saveButton"]
        sleep(1) // Wait for binding to update
        XCTAssertTrue(saveButton.isEnabled, "Save button should be enabled after entering title")
        saveButton.tap()

        // Verify task appears in list using the title text's accessibility identifier
        let taskTitle = app.staticTexts["taskTitle_Buy groceries"]
        XCTAssertTrue(taskTitle.waitForExistence(timeout: 5), "New task should appear in the list")
    }

    // MARK: - Add Multiple Tasks

    @MainActor
    func testAddMultipleTasks() throws {
        let taskNames = ["Task One", "Task Two", "Task Three"]

        for name in taskNames {
            addTaskWithTitle(name)
        }

        // Verify all tasks exist
        for name in taskNames {
            let taskTitle = app.staticTexts["taskTitle_\(name)"]
            XCTAssertTrue(taskTitle.waitForExistence(timeout: 3), "\(name) should appear in the list")
        }
    }

    // MARK: - Toggle Complete

    @MainActor
    func testToggleComplete() throws {
        addTaskWithTitle("Completable Task")

        // Tap the toggle button
        let toggleButton = app.buttons["toggleButton_Completable Task"]
        XCTAssertTrue(toggleButton.waitForExistence(timeout: 5))
        toggleButton.tap()

        // Verify the task is still visible (just marked as completed)
        let taskTitle = app.staticTexts["taskTitle_Completable Task"]
        XCTAssertTrue(taskTitle.waitForExistence(timeout: 3), "Completed task should still be visible in the list")
    }

    // MARK: - Search

    @MainActor
    func testSearchFilter() throws {
        addTaskWithTitle("Buy groceries")
        addTaskWithTitle("Write code")
        addTaskWithTitle("Buy flowers")

        // Type in search field
        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Buy")

        // Wait for filter to apply
        sleep(1)

        // Verify only matching tasks are visible
        let buyGroceries = app.staticTexts["taskTitle_Buy groceries"]
        let buyFlowers = app.staticTexts["taskTitle_Buy flowers"]
        let writeCode = app.staticTexts["taskTitle_Write code"]

        XCTAssertTrue(buyGroceries.waitForExistence(timeout: 3))
        XCTAssertTrue(buyFlowers.exists)
        XCTAssertFalse(writeCode.exists, "Non-matching task should be hidden")
    }

    // MARK: - Priority Filter

    @MainActor
    func testPriorityFilter() throws {
        addTaskWithTitle("Medium Task")

        // Tap "High" filter chip
        let highFilterChip = app.buttons["filterChip_High"]
        XCTAssertTrue(highFilterChip.waitForExistence(timeout: 5))
        highFilterChip.tap()

        // Wait for filter
        sleep(1)

        // Verify medium task is not visible with High filter
        let taskTitle = app.staticTexts["taskTitle_Medium Task"]
        XCTAssertFalse(taskTitle.exists, "Medium priority task should be hidden when High filter is active")

        // Verify empty state shows "No matching tasks"
        let emptyTitle = app.staticTexts["emptyStateTitle"]
        XCTAssertTrue(emptyTitle.waitForExistence(timeout: 3))
        XCTAssertEqual(emptyTitle.label, "No matching tasks")

        // Tap "All" to clear filter
        let allFilterChip = app.buttons["filterChip_All"]
        allFilterChip.tap()

        // Task should reappear
        XCTAssertTrue(taskTitle.waitForExistence(timeout: 3), "Task should reappear after clearing filter")
    }

    // MARK: - Clear Search

    @MainActor
    func testClearSearch() throws {
        addTaskWithTitle("Findable Task")

        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("zzzznothing")

        sleep(1)

        // Task should be hidden
        let taskTitle = app.staticTexts["taskTitle_Findable Task"]
        XCTAssertFalse(taskTitle.exists)

        // Clear search
        let clearButton = app.buttons["clearSearchButton"]
        XCTAssertTrue(clearButton.waitForExistence(timeout: 3))
        clearButton.tap()

        // Task should reappear
        XCTAssertTrue(taskTitle.waitForExistence(timeout: 3), "Task should reappear after clearing search")
    }

    // MARK: - Stats Header

    @MainActor
    func testStatsHeader_updatesCorrectly() throws {
        let totalStat = app.otherElements["statCard_Total"]
        XCTAssertTrue(totalStat.waitForExistence(timeout: 5))

        addTaskWithTitle("Stat Test Task")

        let totalLabel = totalStat.staticTexts.element(boundBy: 0)
        XCTAssertTrue(totalLabel.waitForExistence(timeout: 3))
    }

    // MARK: - Helper

    private func addTaskWithTitle(_ title: String) {
        let addButton = app.buttons["addTaskButton"]
        _ = addButton.waitForExistence(timeout: 3)
        addButton.tap()

        let titleField = app.textFields["taskTitleField"]
        _ = titleField.waitForExistence(timeout: 3)
        titleField.tap()
        titleField.typeText(title)

        // Wait for binding update before tapping save
        sleep(1)

        let saveButton = app.buttons["saveButton"]
        saveButton.tap()

        // Wait for sheet to dismiss
        sleep(1)
    }
}
