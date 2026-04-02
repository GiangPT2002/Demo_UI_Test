//
//  StorageManager.swift
//  Demo_UI_Test
//

import SwiftUI
#if canImport(FirebaseStorage)
import FirebaseStorage
#endif

/// Manager for handling Firebase Cloud Storage operations
final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    /// Uploads an image to Firebase Storage and returns the download URL
    func uploadImage(_ imageData: Data, path: String) async throws -> String {
        #if canImport(FirebaseStorage)
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)
        
        // Setup metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the data
        _ = try await fileRef.putDataAsync(imageData, metadata: metadata)
        
        // Fetch the download URL
        let downloadURL = try await fileRef.downloadURL()
        return downloadURL.absoluteString
        #else
        // Mock upload
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        print("Mock Storage: Uploaded image to \(path)")
        return "https://mock-storage.url/\(path)"
        #endif
    }
}
