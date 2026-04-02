//
//  NavigationUITests.swift
//  Demo_UI_TestUITests
//

import XCTest

final class NavigationUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    // MARK: - App Launch

    @MainActor
    func testAppLaunches_showsNavigationTitle() throws {
        let navTitle = app.navigationBars["My Tasks"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5), "Navigation title 'My Tasks' should be visible")
    }

    // MARK: - Add Button Opens Form

    @MainActor
    func testAddButton_opensFormSheet() throws {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        // Verify form elements are visible
        let formNavTitle = app.navigationBars["New Task"]
        XCTAssertTrue(formNavTitle.waitForExistence(timeout: 5), "Form sheet should show 'New Task' title")

        let titleField = app.textFields["taskTitleField"]
        XCTAssertTrue(titleField.exists, "Title field should be present in form")

        let cancelButton = app.buttons["cancelButton"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should be visible")

        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.exists, "Save button should be visible")
    }

    // MARK: - Form Dismisses on Save

    @MainActor
    func testFormDismisses_onSave() throws {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        // Fill and save
        let titleField = app.textFields["taskTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Dismiss Test")

        app.buttons["saveButton"].tap()

        // Verify form is dismissed (we're back to task list)
        let navTitle = app.navigationBars["My Tasks"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5), "Should return to task list after save")

        // Verify form is no longer visible
        let formNavTitle = app.navigationBars["New Task"]
        XCTAssertFalse(formNavTitle.exists, "Form should be dismissed")
    }

    // MARK: - Form Dismisses on Cancel

    @MainActor
    func testFormDismisses_onCancel() throws {
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        // Verify form is showing
        let formNavTitle = app.navigationBars["New Task"]
        XCTAssertTrue(formNavTitle.waitForExistence(timeout: 5))

        // Cancel
        app.buttons["cancelButton"].tap()

        // Verify we're back at the list
        let navTitle = app.navigationBars["My Tasks"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5), "Should return to task list after cancel")
    }

    // MARK: - Filter Chips Visible

    @MainActor
    func testFilterChips_areVisible() throws {
        let allChip = app.buttons["filterChip_All"]
        XCTAssertTrue(allChip.waitForExistence(timeout: 5), "'All' filter chip should be visible")

        let lowChip = app.buttons["filterChip_Low"]
        XCTAssertTrue(lowChip.exists, "'Low' filter chip should be visible")

        let mediumChip = app.buttons["filterChip_Medium"]
        XCTAssertTrue(mediumChip.exists, "'Medium' filter chip should be visible")

        let highChip = app.buttons["filterChip_High"]
        XCTAssertTrue(highChip.exists, "'High' filter chip should be visible")
    }

    // MARK: - Search Field Visible

    @MainActor
    func testSearchField_isVisible() throws {
        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should be visible on launch")
    }

    // MARK: - Stats Cards Visible

    @MainActor
    func testStatsCards_areVisible() throws {
        let totalCard = app.otherElements["statCard_Total"]
        XCTAssertTrue(totalCard.waitForExistence(timeout: 5), "Total stat card should be visible")

        let pendingCard = app.otherElements["statCard_Pending"]
        XCTAssertTrue(pendingCard.exists, "Pending stat card should be visible")

        let doneCard = app.otherElements["statCard_Done"]
        XCTAssertTrue(doneCard.exists, "Done stat card should be visible")
    }
}
