//
//  TaskFormView.swift
//  Demo_UI_Test
//

import SwiftUI

/// Form view for adding a new task.
struct TaskFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = TaskFormViewModel()

    let onSave: (TaskItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Title Section
                Section {
                    TextField("Task title", text: $viewModel.title)
                        .font(.body)
                        .accessibilityIdentifier("taskTitleField")

                    if let error = viewModel.titleError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.overdueRed)
                            .accessibilityIdentifier("titleErrorLabel")
                    }
                } header: {
                    Text("Title")
                }

                // MARK: - Description Section
                Section {
                    TextField("Description (optional)", text: $viewModel.taskDescription, axis: .vertical)
                        .lineLimit(3...6)
                        .accessibilityIdentifier("taskDescriptionField")
                } header: {
                    Text("Description")
                }

                // MARK: - Priority Section
                Section {
                    Picker("Priority", selection: $viewModel.priority) {
                        ForEach(TaskPriority.allCases) { priority in
                            HStack {
                                Image(systemName: priority.iconName)
                                    .foregroundColor(priority.color)
                                Text(priority.displayName)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("priorityPicker")
                } header: {
                    Text("Priority")
                }

                // MARK: - Due Date Section
                Section {
                    Toggle("Set due date", isOn: $viewModel.hasDueDate)
                        .accessibilityIdentifier("dueDateToggle")

                    if viewModel.hasDueDate {
                        DatePicker(
                            "Due date",
                            selection: $viewModel.dueDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .accessibilityIdentifier("dueDatePicker")
                    }
                } header: {
                    Text("Due Date")
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityIdentifier("cancelButton")
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let task = viewModel.createTask()
                        onSave(task)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(!viewModel.isValid)
                    .accessibilityIdentifier("saveButton")
                }
            }
        }
    }
}

#Preview {
    TaskFormView { task in
        print("Saved: \(task.title)")
    }
}
