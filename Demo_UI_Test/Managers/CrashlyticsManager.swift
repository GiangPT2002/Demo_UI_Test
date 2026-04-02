//
//  CrashlyticsManager.swift
//  Demo_UI_Test
//

import Foundation
#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
#endif

/// Centralized manager for handling Firebase Crashlytics logic.
final class CrashlyticsManager {
    static let shared = CrashlyticsManager()
    
    private init() {}
    
    /// Attaches a given user ID to future crashes for identification in Firebase Console
    func setUserId(_ userId: String) {
        #if canImport(FirebaseCrashlytics)
        Crashlytics.crashlytics().setUserID(userId)
        #else
        print("Mock Crashlytics: Set user ID to \(userId)")
        #endif
    }
    
    /// Forces a fatal crash for testing purposes
    func forceCrash() {
        #if canImport(FirebaseCrashlytics)
        // This simulates a hard crash so Firebase can symbolicate and upload the stack trace.
        fatalError("Developer initiated Force Crash for Crashlytics Testing.")
        #else
        print("Mock Crashlytics: Simulated a crash. (Would fatally crash the app if SDK was linked).")
        #endif
    }
}
