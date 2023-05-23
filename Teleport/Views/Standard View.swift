//  Copyright (c) 2023 Maxim Levey
//
//  Teleport is licensed under the MIT license.
//  You may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://github.com/maximlevey/Teleport/blob/main/LICENSE

// MARK: - Imports

import AppKit
import Foundation
import SwiftUI

// MARK: - Popover View

struct StandardView: View {
  // Instance of ProcessManager.
  @ObservedObject var processManager = ProcessManager.shared
  // Instance of PreferenceManager.
  @ObservedObject var preferenceManager = PreferenceManager.shared
  // Boolean to handle display of PreferenceView
  @State private var showPreferenceView = false
  // MARK: - View Content
  var body: some View {
    VStack {
      if showPreferenceView {
        PreferenceView(showPreferenceView: $showPreferenceView)
      } else {
        VStack(alignment: .center) {
          if let image = NSImage(named: "AppIcon") {
            Image(nsImage: image)
              .resizable()
              .frame(width: 64, height: 64)
          }
          Text("Teleport")
            .font(.system(size: 18, weight: .bold))
            .frame(height: 5)
            .foregroundColor(Color(NSColor.textColor))
            .padding(.top, 1.5)
            .padding(.bottom, 1.5)
          Text("Version 0.2")
            .font(.footnote)
            .frame(height: 5)
            .foregroundColor(.gray)
            .padding(.top, 1.5)
        }
        .frame(width: 125, height: 90)
        VStack(alignment: .center, spacing: 0) {
          Button(action: {
            processManager.toggleMessageHandler()
            preferenceManager.teleportPaused = !processManager.isRunning
            // swiftlint:disable:next multiple_closures_with_trailing_closure
          }) {
            Text(processManager.isRunning ? "Pause Teleport" : "Start Teleport")
              .font(.system(size: 12))
              .fontWeight(.regular)
          }
          .padding(.top, 3)
          .padding(.bottom, 3)
          .buttonStyle(PrimaryButtonStyle(height: 22, width: 125))
          Button(action: {
            NSApplication.shared.terminate(nil)
            // swiftlint:disable:next multiple_closures_with_trailing_closure
          }) {
            Text("Quit Teleport")
              .font(.system(size: 12))
              .fontWeight(.regular)
              .foregroundColor(Color(NSColor.textColor))
          }
          .padding(.top, 3)
          .padding(.bottom, 3)
          .buttonStyle(SecondaryButtonStyle(height: 22, width: 125))
          Button(action: {
            showPreferenceView.toggle()
            // swiftlint:disable:next multiple_closures_with_trailing_closure
          }) {
            Text("Notifications")
              .font(.system(size: 12))
              .fontWeight(.regular)
              .foregroundColor(Color(NSColor.textColor))
          }
          .padding(.top, 3)
          .padding(.bottom, 1.5)
          .buttonStyle(SecondaryButtonStyle(height: 22, width: 125))
        }
        .frame(width: 125, height: 105)
        VStack(alignment: .center, spacing: 2) {
          Text("MIT License")
            .font(.footnote)
            .frame(height: 5)
            .foregroundColor(.gray)
            .padding(.top, 1.5)
            .padding(.bottom, 3)
          Text("Copyright (c) 2023 Maxim Levey")
            .font(.footnote)
            .frame(height: 5)
            .foregroundColor(.gray)
            .padding(.top, 3)
            .padding(.bottom, 3)
          Link("View on Github", destination: URL(string: "https://github.com/maximlevey")!)
            .font(.footnote)
            .frame(height: 5)
            .foregroundColor(.gray)
            .underline()
            .padding(.top, 3)
        }
      }
    }
    .frame(width: 200, height: 275)
    .background(Color(NSColor.windowBackgroundColor))
  }
}
