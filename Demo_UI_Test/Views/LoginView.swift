//
//  LoginView.swift
//  Demo_UI_Test
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(RemoteConfigManager.self) private var remoteConfigManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.badge.questionmark.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.appPrimary, .appSecondary],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .padding(.bottom, 8)

                            Text(remoteConfigManager.welcomeMessage)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .accessibilityIdentifier("loginTitle")

                            Text("Sign in to manage your tasks")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)

                        // Input Fields
                        VStack(spacing: 16) {
                            CustomTextField(
                                iconName: "envelope",
                                placeholder: "Email address",
                                text: $email,
                                keyboardType: .emailAddress
                            )
                            .accessibilityIdentifier("emailField")

                            CustomTextField(
                                iconName: "lock",
                                placeholder: "Password",
                                text: $password,
                                isSecure: true
                            )
                            .accessibilityIdentifier("passwordField")

                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                    // Action here
                                }
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(.appPrimary)
                            }
                        }

                        // Error Message
                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.overdueRed)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .accessibilityIdentifier("authErrorLabel")
                        }

                        // Main Login Button
                        Button {
                            Task {
                                await authViewModel.signIn(email: email, password: password)
                            }
                        } label: {
                            Group {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Sign In")
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
                        .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                        .accessibilityIdentifier("signInButton")
                        .padding(.top, 8)

                        // Divider
                        HStack {
                            VStack { Divider().background(Color.textSecondary.opacity(0.3)) }
                            Text("Or continue with")
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
                                title: "Continue with Google",
                                foregroundColor: .primary,
                                backgroundColor: Color(.systemBackground)
                            ) {
                                Task { await authViewModel.signInWithGoogle() }
                            }

                            SocialLoginButton(
                                iconName: "applelogo",
                                title: "Continue with Apple",
                                foregroundColor: .white,
                                backgroundColor: .primary
                            ) {}

                            SocialLoginButton(
                                iconName: "facebook_logo",
                                title: "Continue with Facebook",
                                foregroundColor: .white,
                                backgroundColor: Color(red: 24/255, green: 119/255, blue: 242/255) // Standard Facebook blue
                            ) {}
                        }

                        Spacer(minLength: 40)

                        // Sign up link
                        Button {
                            showSignup = true
                        } label: {
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundColor(.textSecondary)
                                Text("Sign Up")
                                    .fontWeight(.bold)
                                    .foregroundColor(.appPrimary)
                            }
                            .font(.subheadline)
                        }
                        .accessibilityIdentifier("showSignupButton")
                        .navigationDestination(isPresented: $showSignup) {
                            SignupView()
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
