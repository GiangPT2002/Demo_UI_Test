//
//  RemoteConfigManager.swift
//  Demo_UI_Test
//

import SwiftUI
#if canImport(FirebaseRemoteConfig)
import FirebaseRemoteConfig
#endif

/// Manager for fetching real-time configuration values from Firebase Remote Config.
@Observable
final class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    /// Dynamic welcome message fetched from cloud
    var welcomeMessage: String = "Welcome Back"
    
    /// Dynamic hex color fetched from cloud for the primary theme
    var primaryThemeColorHex: String = "" // Empty means use default
    
    private init() {
        #if canImport(FirebaseRemoteConfig)
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        // Minimum fetch interval is 0 for testing, but should be higher in production (e.g., 3600 = 1 hour)
        settings.minimumFetchInterval = 0 
        remoteConfig.configSettings = settings
        
        // Set default values before fetching
        remoteConfig.setDefaults([
            "welcome_message": "Welcome Back" as NSObject,
            "primary_theme_color": "" as NSObject
        ])
        #endif
    }
    
    /// Fetches and activates the latest configuration from Firebase
    func fetchConfig() {
        #if canImport(FirebaseRemoteConfig)
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard error == nil else {
                print("Error fetching remote config: \(error!.localizedDescription)")
                return
            }
            
            // Read values
            let message = remoteConfig.configValue(forKey: "welcome_message").stringValue ?? "Welcome Back"
            let colorHex = remoteConfig.configValue(forKey: "primary_theme_color").stringValue ?? ""
            
            DispatchQueue.main.async {
                self?.welcomeMessage = message
                self?.primaryThemeColorHex = colorHex
                print("Remote Config Fetched: Message='\(message)', Color='\(colorHex)'")
            }
        }
        #else
        print("Mock Remote Config: Using defaults since SDK is not imported.")
        #endif
    }
}
