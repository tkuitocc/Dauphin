//
//  campuspass_iosApp.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/14/24.
//

import SwiftUI

@main
struct campuspass_iosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try await KeyConstants.loadAPIKeys()
                        print("API Keys Loaded Successfully")
                    } catch {
                        print("Failed to load API keys. Error: \(error)")
                    }
                }
        }
    }
}
