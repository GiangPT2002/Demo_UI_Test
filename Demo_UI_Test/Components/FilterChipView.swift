//
//  FilterChipView.swift
//  Demo_UI_Test
//

import SwiftUI

/// Horizontal scrolling filter chips for task priority.
struct FilterChipView: View {
    @Binding var selectedFilter: TaskPriority?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "All" chip
                chipButton(
                    label: "All",
                    isSelected: selectedFilter == nil,
                    color: .appPrimary
                ) {
                    selectedFilter = nil
                }
                .accessibilityIdentifier("filterChip_All")

                // Priority chips
                ForEach(TaskPriority.allCases) { priority in
                    chipButton(
                        label: priority.displayName,
                        isSelected: selectedFilter == priority,
                        color: priority.color
                    ) {
                        if selectedFilter == priority {
                            selectedFilter = nil
                        } else {
                            selectedFilter = priority
                        }
                    }
                    .accessibilityIdentifier("filterChip_\(priority.rawValue)")
                }
            }
            .padding(.horizontal)
        }
    }

    private func chipButton(
        label: String,
        isSelected: Bool,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? color : color.opacity(0.1))
                .foregroundColor(isSelected ? .white : color)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var filter: TaskPriority? = nil
        var body: some View {
            FilterChipView(selectedFilter: $filter)
        }
    }
    return PreviewWrapper()
}
