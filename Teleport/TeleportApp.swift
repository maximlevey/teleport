//
//  TeleportApp.swift
//  Teleport Beta
//
//  Created by Maxim Levey
//

import SwiftUI

// MARK: - Main App

@main
struct TeleportApp: App {
    // Adaptor to connect the AppDelegate.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // Body of the application.
    var body: some Scene {
        // Scene for settings.
        Settings {
            // Empty view as we're just setting up the app.
            EmptyView()
        }
    }
}
