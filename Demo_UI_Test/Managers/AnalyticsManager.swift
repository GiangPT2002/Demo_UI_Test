//
//  AnalyticsManager.swift
//  Demo_UI_Test
//

import Foundation
#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif

/// Centralized manager for logging all Firebase Analytics events.
final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    /// Logs when a user successfully signs in
    func logLogin(method: String) {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent(AnalyticsEventLogin, parameters: [
            AnalyticsParameterMethod: method
        ])
        #else
        print("Mock Analytics Log: User logged in via \(method)")
        #endif
    }
    
    /// Logs when a user successfully signs up
    func logSignUp(method: String) {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent(AnalyticsEventSignUp, parameters: [
            AnalyticsParameterMethod: method
        ])
        #else
        print("Mock Analytics Log: User signed up via \(method)")
        #endif
    }
    
    /// Logs when a task is created
    func logTaskCreated(priority: String) {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent("task_created", parameters: [
            "priority": priority
        ])
        #else
        print("Mock Analytics Log: Task Created [Priority: \(priority)]")
        #endif
    }
    
    /// Logs when a task is completed or uncompleted
    func logTaskCompletionChanged(isCompleted: Bool) {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent(isCompleted ? "task_completed" : "task_uncompleted", parameters: nil)
        #else
        print("Mock Analytics Log: Task Completion Changed to \(isCompleted)")
        #endif
    }
    
    /// Logs when a task is deleted
    func logTaskDeleted() {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent("task_deleted", parameters: nil)
        #else
        print("Mock Analytics Log: Task Deleted")
        #endif
    }
}
