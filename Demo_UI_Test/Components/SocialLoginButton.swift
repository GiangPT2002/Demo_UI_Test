//
//  SocialLoginButton.swift
//  Demo_UI_Test
//

import SwiftUI

/// Reusable component for Social Login buttons (Google, Apple, Facebook)
struct SocialLoginButton: View {
    let iconName: String
    let title: String
    let foregroundColor: Color
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                // Determine if it's a system (SF Symbol) or custom asset
                if iconName == "applelogo" {
                    Image(systemName: iconName)
                        .font(.system(size: 20))
                } else {
                    // Assuming Google logo uses a custom image or an SF Symbol workaround
                    // If you add a "google_logo" to Assets.xcassets, it will use that.
                    // For now, we fallback to a colored circle if image is missing.
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        // Fallback in case image asset is absent:
                        .controlSize(.regular)
                }

                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("socialBtn_\(title)")
    }
}

#Preview {
    VStack(spacing: 16) {
        SocialLoginButton(
            iconName: "google_logo", // You will need to add this image to Assets
            title: "Continue with Google",
            foregroundColor: .primary,
            backgroundColor: Color(.systemBackground)
        ) {}

        SocialLoginButton(
            iconName: "applelogo", // SF Symbol
            title: "Continue with Apple",
            foregroundColor: .white,
            backgroundColor: .primary
        ) {}

        SocialLoginButton(
            iconName: "f.logo.square.fill", // SF Symbol
            title: "Continue with Facebook",
            foregroundColor: .white,
            backgroundColor: Color(red: 24/255, green: 119/255, blue: 242/255)
        ) {}
    }
    .padding()
    .background(Color.appBackground)
}
