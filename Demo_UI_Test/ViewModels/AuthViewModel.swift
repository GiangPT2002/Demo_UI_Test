//
//  AuthViewModel.swift
//  Demo_UI_Test
//

import SwiftUI
#if canImport(FirebaseCore)
import FirebaseCore
#endif
#if canImport(FirebaseAuth)
import FirebaseAuth
#endif
#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

@Observable
final class AuthViewModel {
    var isAuthenticated: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil

    init() {
        // checkAuthState is now called from ContentView's .task to ensure FirebaseApp is configured first.
    }

    func checkAuthState() {
        #if canImport(FirebaseAuth)
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        }
        #endif
    }

    @MainActor
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        #if canImport(FirebaseAuth)
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            if result.user.uid.isEmpty == false {
                isAuthenticated = true
                AnalyticsManager.shared.logLogin(method: "Email")
                CrashlyticsManager.shared.setUserId(result.user.uid)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        #else
        // Mock authentication for UI testing if Firebase is not yet linked
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        if email.contains("@") && password.count >= 6 {
            isAuthenticated = true
            AnalyticsManager.shared.logLogin(method: "Email (Mock)")
            CrashlyticsManager.shared.setUserId("mock_user_email")
        } else {
            errorMessage = "Invalid email or password (Mock Error). Please ensure email contains '@' and password has 6+ chars."
        }
        #endif
        
        isLoading = false
    }

    @MainActor
    func signUp(name: String, email: String, password: String, avatarData: Data? = nil) async {
        isLoading = true
        errorMessage = nil
        
        #if canImport(FirebaseAuth)
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            
            // Upload Avatar if provided
            if let data = avatarData {
                if let urlStr = try? await StorageManager.shared.uploadImage(data, path: "users/\(result.user.uid)/avatar.jpg") {
                    changeRequest.photoURL = URL(string: urlStr)
                }
            }
            
            try await changeRequest.commitChanges()
            
            isAuthenticated = true
            AnalyticsManager.shared.logSignUp(method: "Email")
            CrashlyticsManager.shared.setUserId(result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
        #else
        // Mock signup for UI testing
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        if email.contains("@") && password.count >= 6 && !name.isEmpty {
            isAuthenticated = true
            AnalyticsManager.shared.logSignUp(method: "Email (Mock)")
            CrashlyticsManager.shared.setUserId("mock_user_signup")
        } else {
            errorMessage = "Please fill out all fields correctly (Mock Error)."
        }
        #endif
        
        isLoading = false
    }

    @MainActor
    func signInWithGoogle() async {
        isLoading = true
        errorMessage = nil
        
        #if canImport(GoogleSignIn) && canImport(FirebaseAuth)
        do {
            // Get the client ID from Firebase config
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                errorMessage = "Firebase client ID not found. Ensure GoogleService-Info.plist is added."
                isLoading = false
                return
            }
            
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            // Get root view controller to present the Google Sign in window
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                errorMessage = "Could not find root view controller to present Google Sign-In."
                isLoading = false
                return
            }
            
            // Start the sign in flow!
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                errorMessage = "Google authentication failed: Missing ID token."
                isLoading = false
                return
            }
            let accessToken = result.user.accessToken.tokenString
            
            // Authenticate with Firebase using the Google credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            let authResult = try await Auth.auth().signIn(with: credential)
            
            if !authResult.user.uid.isEmpty {
                isAuthenticated = true
            }
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
        #else
        // Fallback for UI testing if the module isn't strictly imported yet
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isAuthenticated = true
        isLoading = false
        #endif
    }

    @MainActor
    func signOut() {
        #if canImport(FirebaseAuth)
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("Error signing out: \(error)")
        }
        #else
        isAuthenticated = false
        #endif
    }
}
