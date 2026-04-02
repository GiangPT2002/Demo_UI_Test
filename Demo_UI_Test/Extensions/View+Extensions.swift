//
//  View+Extensions.swift
//  Demo_UI_Test
//

import SwiftUI

// MARK: - Card Style Modifier

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Shake Animation Modifier

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * shakesPerUnit),
                y: 0
            )
        )
    }
}

// MARK: - View Extension

extension View {
    /// Applies a card-like appearance with shadow and rounded corners
    func cardStyle() -> some View {
        modifier(CardModifier())
    }

    /// Adds a shake animation triggered by the given value
    func shake(trigger: CGFloat) -> some View {
        modifier(ShakeEffect(animatableData: trigger))
    }

    /// Conditionally applies a modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
