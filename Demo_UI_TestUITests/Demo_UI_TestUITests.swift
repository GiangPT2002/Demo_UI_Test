//
//  Demo_UI_TestUITests.swift
//  Demo_UI_TestUITests
//
//  Created by Trường Giang Phạm on 30/3/26.
//

import XCTest

final class Demo_UI_TestUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Cleanup if needed
    }

    @MainActor
    func testAppLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Verify the app launched successfully with the main screen
        let navTitle = app.navigationBars["My Tasks"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5), "App should launch with 'My Tasks' screen")

        // Verify the add button is present
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.exists, "Add task button should be visible")
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
