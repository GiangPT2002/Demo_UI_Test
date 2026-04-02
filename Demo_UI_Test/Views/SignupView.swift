//
//  SignupView.swift
//  Demo_UI_Test
//

import SwiftUI
import PhotosUI

struct SignupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var avatarItem: PhotosPickerItem? = nil
    @State private var avatarData: Data? = nil

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .accessibilityIdentifier("signupTitle")

                        Text("Start organizing your life today")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    // Avatar Picker
                    PhotosPicker(
                        selection: $avatarItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                        if let data = avatarData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.appPrimary, lineWidth: 2))
                        } else {
                            VStack {
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.appPrimary)
                                Text("Add Photo")
                                    .font(.caption)
                                    .foregroundColor(.appPrimary)
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                    .padding(.bottom, 16)
                    .onChange(of: avatarItem) { _, newValue in
                        Task {
                            if let loadedData = try? await newValue?.loadTransferable(type: Data.self) {
                                avatarData = loadedData
                            }
                        }
                    }

                    // Input Fields
                    VStack(spacing: 16) {
                        CustomTextField(
                            iconName: "person",
                            placeholder: "Full Name",
                            text: $name
                        )
                        .accessibilityIdentifier("nameSignupField")

                        CustomTextField(
                            iconName: "envelope",
                            placeholder: "Email address",
                            text: $email,
                            keyboardType: .emailAddress
                        )
                        .accessibilityIdentifier("emailSignupField")

                        CustomTextField(
                            iconName: "lock",
                            placeholder: "Password",
                            text: $password,
                            isSecure: true
                        )
                        .accessibilityIdentifier("passwordSignupField")
                    }

                    // Error Message
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.overdueRed)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    // Main Signup Button
                    Button {
                        Task {
                            await authViewModel.signUp(name: name, email: email, password: password, avatarData: avatarData)
                        }
                    } label: {
                        Group {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign Up")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.appPrimary, .appSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .appPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(authViewModel.isLoading || name.isEmpty || email.isEmpty || password.isEmpty)
                    .accessibilityIdentifier("signUpButton")
                    .padding(.top, 8)

                    // Divider
                    HStack {
                        VStack { Divider().background(Color.textSecondary.opacity(0.3)) }
                        Text("Or sign up with")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 8)
                        VStack { Divider().background(Color.textSecondary.opacity(0.3)) }
                    }
                    .padding(.vertical, 16)

                    // Social Logins
                    VStack(spacing: 16) {
                        SocialLoginButton(
                            iconName: "google_logo",
                            title: "Sign up with Google",
                            foregroundColor: .primary,
                            backgroundColor: Color(.systemBackground)
                        ) {
                            Task { await authViewModel.signInWithGoogle() }
                        }

                        SocialLoginButton(
                            iconName: "applelogo",
                            title: "Sign up with Apple",
                            foregroundColor: .white,
                            backgroundColor: .primary
                        ) {}

                        SocialLoginButton(
                            iconName: "facebook_logo",
                            title: "Sign up with Facebook",
                            foregroundColor: .white,
                            backgroundColor: Color(red: 24/255, green: 119/255, blue: 242/255)
                        ) {}
                    }

                    Spacer(minLength: 40)

                    // Login link
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(.textSecondary)
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundColor(.appPrimary)
                        }
                        .font(.subheadline)
                    }
                    .accessibilityIdentifier("showLoginButton")
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignupView()
        .environment(AuthViewModel())
}
