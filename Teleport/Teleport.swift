//  Copyright (c) 2023 Maxim Levey
//
//  Teleport is licensed under the MIT license.
//  You may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://github.com/maximlevey/Teleport/blob/main/LICENSE

// MARK: - Imports

import SwiftUI

// MARK: - Application Structure

@main
struct Teleport: App {
  // Shared instance to manage app processes and lifecycle events.
  @StateObject private var processManager = ProcessManager.shared
  // Define app user interface and behaviour.
  var body: some Scene {
    MenuBarExtra("Teleport", systemImage: "clipboard") {
      // Setup path to user's message database.
      let dbPath = NSString(string: "~/Library/Messages/chat.db").expandingTildeInPath
      // Check if the message database file is accessible.
      // Load different views based on the file's accessibility.
      if FileManager.default.isReadableFile(atPath: dbPath) {
        StandardView() // File is accessible, load the standard view.
      } else {
        PermissionView() // File is not accessible, request for permission.
      }
    }
    // Set style to make the menu bar behave like a regular app window.
    .menuBarExtraStyle(.window)
  }
}
