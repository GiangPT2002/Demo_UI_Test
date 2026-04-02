//
//  TaskListView.swift
//  Demo_UI_Test
//

import SwiftUI

/// Main view showing the list of tasks with search, filter, and add capabilities.
struct TaskListView: View {
    @Bindable var viewModel: TaskListViewModel
    @Environment(AuthViewModel.self) private var authViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - Header Stats
                    headerStats

                    // MARK: - Search Bar
                    searchBar

                    // MARK: - Filter Chips
                    FilterChipView(selectedFilter: $viewModel.selectedFilter)
                        .padding(.vertical, 8)

                    // MARK: - Task List
                    if viewModel.isFilteredListEmpty {
                        EmptyStateView(
                            hasFiltersApplied: viewModel.selectedFilter != nil || !viewModel.searchText.isEmpty
                        )
                    } else {
                        taskListContent
                    }
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.isShowingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.appPrimary, .appSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .accessibilityIdentifier("addTaskButton")
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(role: .destructive) {
                            authViewModel.signOut()
                        } label: {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        
                        if !viewModel.tasks.isEmpty {
                            Divider()
                            
                            Button(role: .destructive) {
                                withAnimation {
                                    viewModel.deleteAll()
                                }
                            } label: {
                                Label("Delete All Tasks", systemImage: "trash")
                            }
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            CrashlyticsManager.shared.forceCrash()
                        } label: {
                            Label("Force Crash (Test)", systemImage: "xmark.octagon.fill")
                        }
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                            .foregroundColor(.appPrimary)
                    }
                    .accessibilityIdentifier("profileMenuButton")
                }
            }
            .sheet(isPresented: $viewModel.isShowingAddTask) {
                TaskFormView { task in
                    withAnimation(.spring(response: 0.4)) {
                        viewModel.addTask(task)
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private var headerStats: some View {
        HStack(spacing: 16) {
            statCard(title: "Total", value: "\(viewModel.totalCount)", color: .appPrimary)
            statCard(title: "Pending", value: "\(viewModel.pendingCount)", color: .priorityMedium)
            statCard(title: "Done", value: "\(viewModel.completedCount)", color: .completedGreen)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .accessibilityIdentifier("statsHeader")
    }

    private func statCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        .accessibilityIdentifier("statCard_\(title)")
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)

            TextField("Search tasks...", text: $viewModel.searchText)
                .accessibilityIdentifier("searchField")

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                }
                .accessibilityIdentifier("clearSearchButton")
            }
        }
        .padding(10)
        .background(Color.cardBackground)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var taskListContent: some View {
        List {
            ForEach(viewModel.filteredTasks) { task in
                TaskRowView(task: task) {
                    withAnimation(.spring(response: 0.3)) {
                        if let id = task.id {
                            viewModel.toggleComplete(id: id)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation {
                            if let id = task.id {
                                viewModel.deleteTask(id: id)
                            }
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .accessibilityIdentifier("taskList")
    }
}

#Preview {
    let vm = TaskListViewModel()
    vm.loadSampleData()
    return TaskListView(viewModel: vm)
        .environment(AuthViewModel())
}
