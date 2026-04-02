//
//  Demo_UI_TestTests.swift
//  Demo_UI_TestTests
//
//  Created by Trường Giang Phạm on 30/3/26.
//

import Testing
@testable import Demo_UI_Test

struct Demo_UI_TestTests {

    @Test func testTaskPriority_allCases() {
        #expect(TaskPriority.allCases.count == 3)
        #expect(TaskPriority.allCases.contains(.low))
        #expect(TaskPriority.allCases.contains(.medium))
        #expect(TaskPriority.allCases.contains(.high))
    }

    @Test func testTaskPriority_sortOrder() {
        #expect(TaskPriority.low.sortOrder < TaskPriority.medium.sortOrder)
        #expect(TaskPriority.medium.sortOrder < TaskPriority.high.sortOrder)
    }

    @Test func testTaskPriority_displayNames() {
        #expect(TaskPriority.low.displayName == "Low")
        #expect(TaskPriority.medium.displayName == "Medium")
        #expect(TaskPriority.high.displayName == "High")
    }
}
