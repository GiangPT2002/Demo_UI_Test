//
//  Demo_UI_TestApp.swift
//  Demo_UI_Test
//
//  Created by Trường Giang Phạm on 30/3/26.
//

import SwiftUI
#if canImport(FirebaseCore)
import FirebaseCore
#endif

@main
struct Demo_UI_TestApp: App {
    @State private var viewModel = TaskListViewModel()
    @State private var authViewModel = AuthViewModel()
    
    init() {
        #if canImport(FirebaseCore)
        // Configure Firebase before any views are rendered
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        #endif
        
        // Fetch remote configuration
        RemoteConfigManager.shared.fetchConfig()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environment(authViewModel)
                .environment(RemoteConfigManager.shared)
        }
    }
}
