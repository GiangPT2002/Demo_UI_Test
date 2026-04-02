//
//  CustomTextField.swift
//  Demo_UI_Test
//

import SwiftUI

/// Standardized text field with optional icon and secure entry support.
struct CustomTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(.textSecondary)
                .frame(width: 24)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .textContentType(.password)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        .accessibilityIdentifier("customTextField_\(placeholder)")
    }
}

#Preview {
    VStack {
        CustomTextField(iconName: "envelope", placeholder: "Email", text: .constant(""))
        CustomTextField(iconName: "lock", placeholder: "Password", text: .constant(""), isSecure: true)
    }
    .padding()
    .background(Color.appBackground)
}
