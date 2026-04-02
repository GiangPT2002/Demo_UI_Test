//
//  TaskFormUITests.swift
//  Demo_UI_TestUITests
//

import XCTest

final class TaskFormUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    // MARK: - Form Validation

    @MainActor
    func testFormValidation_saveDisabledWhenTitleEmpty() throws {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5))
        XCTAssertFalse(saveButton.isEnabled, "Save button should be disabled when title is empty")
    }

    @MainActor
    func testFormValidation_saveEnabledAfterTypingTitle() throws {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let titleField = app.textFields["taskTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Valid Task")

        // Wait for @Observable binding to propagate to toolbar button state
        sleep(1)

        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.isEnabled, "Save button should be enabled with valid title")
    }

    // MARK: - Fill Form and Save

    @MainActor
    func testFormFillAndSave() throws {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        // Fill title
        let titleField = app.textFields["taskTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Complete Project")

        // Fill description — TextField with axis: .vertical may appear as textView
        let descField = app.textViews["taskDescriptionField"].exists
            ? app.textViews["taskDescriptionField"]
            : app.textFields["taskDescriptionField"]
        if descField.waitForExistence(timeout: 3) {
            descField.tap()
            descField.typeText("Finish all remaining tasks")
        }

        // Toggle due date on
        let dueDateToggle = app.switches["dueDateToggle"]
        XCTAssertTrue(dueDateToggle.waitForExistence(timeout: 3))
        dueDateToggle.tap()

        // Verify date picker appears
        let datePicker = app.datePickers["dueDatePicker"]
        XCTAssertTrue(datePicker.waitForExistence(timeout: 3), "Date picker should appear after toggle")

        // Wait for binding then Save
        sleep(1)
        let saveButton = app.buttons["saveButton"]
        saveButton.tap()

        // Verify task appears in list
        let taskTitle = app.staticTexts["taskTitle_Complete Project"]
        XCTAssertTrue(taskTitle.waitForExistence(timeout: 5), "Saved task should appear in list")
    }

    // MARK: - Cancel Form

    @MainActor
    func testCancelForm_doesNotAddTask() throws {
        // Add a task first
        addTaskWithTitle("Existing Task")

        // Open form and cancel
        let addButton = app.buttons["addTaskButton"]
        addButton.tap()

        let titleField = app.textFields["taskTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Cancelled Task")

        let cancelButton = app.buttons["cancelButton"]
        cancelButton.tap()

        // Wait for sheet to dismiss
        sleep(1)

        // Verify the cancelled task does NOT appear
        let cancelledTitle = app.staticTexts["taskTitle_Cancelled Task"]
        XCTAssertFalse(cancelledTitle.exists, "Cancelled task should not appear in list")

        // Verify original task still exists
        let existingTitle = app.staticTexts["taskTitle_Existing Task"]
        XCTAssertTrue(existingTitle.exists, "Existing task should still be in list")
    }

    // MARK: - Due Date Toggle

    @MainActor
    func testDueDateToggle() throws {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let dueDateToggle = app.switches["dueDateToggle"]
        XCTAssertTrue(dueDateToggle.waitForExistence(timeout: 5))

        // Initially, date picker should not be visible
        let datePicker = app.datePickers["dueDatePicker"]
        XCTAssertFalse(datePicker.exists, "Date picker should be hidden initially")

        // Toggle on
        dueDateToggle.tap()
        XCTAssertTrue(datePicker.waitForExistence(timeout: 3), "Date picker should appear after toggle on")

        // Toggle off
        dueDateToggle.tap()
        sleep(1)
        XCTAssertFalse(datePicker.exists, "Date picker should disappear after toggle off")
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

        sleep(1) // Wait for binding

        let saveButton = app.buttons["saveButton"]
        saveButton.tap()
        sleep(1)
    }
}
