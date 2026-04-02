//
//  EmptyStateView.swift
//  Demo_UI_Test
//

import SwiftUI

/// View displayed when the task list is empty.
struct EmptyStateView: View {
    let hasFiltersApplied: Bool

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.appPrimary, .appSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .accessibilityIdentifier("emptyStateIcon")

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .accessibilityIdentifier("emptyStateTitle")

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .accessibilityIdentifier("emptyStateSubtitle")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 60)
    }

    private var icon: String {
        hasFiltersApplied ? "line.3.horizontal.decrease.circle" : "checklist"
    }

    private var title: String {
        hasFiltersApplied ? "No matching tasks" : "No tasks yet"
    }

    private var subtitle: String {
        hasFiltersApplied
            ? "Try changing your search or filters"
            : "Tap the + button to add your first task"
    }
}

#Preview("Empty") {
    EmptyStateView(hasFiltersApplied: false)
}

#Preview("Filtered") {
    EmptyStateView(hasFiltersApplied: true)
}
