//
//  ContentView.swift
//  Demo_UI_Test
//
//  Created by Trường Giang Phạm on 30/3/26.
//

import SwiftUI

/// Root content view that displays the TaskListView.
struct ContentView: View {
    @Bindable var viewModel: TaskListViewModel
    @Environment(AuthViewModel.self) private var authViewModel

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                TaskListView(viewModel: viewModel)
                    .transition(.opacity) // Smooth fade when logged in
            } else {
                LoginView()
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
        .task {
            authViewModel.checkAuthState()
        }
    }
}

#Preview {
    let vm = TaskListViewModel()
    vm.loadSampleData()
    return ContentView(viewModel: vm)
        .environment(AuthViewModel())
}
